import 'package:flutter_assignment/bloc/api_bloc.dart';
import 'package:flutter_assignment/model/covid_model.dart';
import 'package:flutter_assignment/resources/api_provider.dart';
import 'package:flutter_assignment/resources/api_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

class TestProvider extends Mock implements ApiProvider {
  ApiProvider _apiProvider;
  TestProvider() {
    _apiProvider = ApiProvider();
    when(_apiProvider.getFeedList())
        .thenAnswer((_) => _apiProvider.getFeedList());
  }
}

void main() {
  ApiRepository apiRepository;

  group("fetchFeedList", () {
    test('should called fetchFeedList from FetchApiClient', () async {
      when(apiRepository.fetchFeedList()).thenAnswer((_) async {
        return Future.value();
      });
      apiRepository.fetchFeedList();

      verify(apiRepository.fetchFeedList()).called(1);
    });
  });

  group("fetchFeedList Props", () {
    test("Correct Props", () {
      expect(GetApiList().props, []);
    });
  });
}
