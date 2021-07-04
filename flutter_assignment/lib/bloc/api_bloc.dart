import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_assignment/model/covid_model.dart';
import 'package:flutter_assignment/resources/api_repository.dart';
import 'package:equatable/equatable.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiRepository apiRepository;

  ApiBloc({this.apiRepository}) : assert(apiRepository != null);

  @override
  ApiState get initialState => ApiInitState();

  @override
  Stream<ApiState> mapEventToState(ApiEvent apiEvent) async* {
    // TODO: implement mapEventToState

    if (apiEvent is GetApiList) {
      yield ApiLoading();
      try {
        final mList = await apiRepository.fetchFeedList();
        yield ApiLoaded(mList);
        if (mList.error != null) {
          yield ApiError(mList.error);
        }
      } on NetworkError {
        yield ApiError("Failed to fetch data. is your device online?");
      }
    }
  }
}
