import 'package:flutter/cupertino.dart';
import 'package:flutter_assignment/model/covid_model.dart';
import 'api_provider.dart';

class ApiRepository {
  final ApiProvider provider;
  ApiRepository({@required this.provider}) : assert(provider != null);

  Future<CovidModel> fetchFeedList() {
    return provider.getFeedList();
  }
}

class NetworkError extends Error {}
