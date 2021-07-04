import 'package:flutter_assignment/model/covid_model.dart';
import 'package:flutter_assignment/utils/util.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  ApiProvider() : assert(Util.URL != null);
  Future<CovidModel> getFeedList() async {
    try {
      var response = await http.get(Util.URL);
      var jsons = jsonDecode(response.body);
      return CovidModel.fromJson(jsons);
    } catch (error, stacktrace) {
      print("Error : $error. StackTrace : $stacktrace");
      return CovidModel.withError("Data not found / Connection issue");
    }
  }
}
