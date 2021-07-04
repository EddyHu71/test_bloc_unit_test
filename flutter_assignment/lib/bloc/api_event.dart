part of 'api_bloc.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();
}

class GetApiList extends ApiEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
