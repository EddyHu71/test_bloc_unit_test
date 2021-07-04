import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_assignment/bloc/api_bloc.dart';
import 'package:flutter_assignment/model/covid_model.dart';
import 'package:flutter_assignment/resources/api_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockApiRepository extends Mock implements ApiRepository {}

void main() {
  ApiBloc apiBloc;
  ApiRepository apiRepository;

  final Global global = Global(
      newConfirmed: 2,
      totalConfirmed: 10,
      newDeaths: 2,
      totalDeaths: 10,
      newRecovered: 20,
      totalRecovered: 10);
  List<Countries> listcountries = [
    Countries(
        country: "Indonesia",
        countryCode: "62",
        slug: "100",
        newConfirmed: 2,
        totalConfirmed: 10,
        newDeaths: 2,
        totalDeaths: 10,
        newRecovered: 20,
        totalRecovered: 10,
        date: "2021-04-07"),
    Countries(
        country: "Indonesia",
        countryCode: "62",
        slug: "100",
        newConfirmed: 2,
        totalConfirmed: 10,
        newDeaths: 2,
        totalDeaths: 10,
        newRecovered: 20,
        totalRecovered: 10,
        date: "2021-04-07"),
  ];
  final CovidModel covidModel =
      CovidModel(global: global, countries: listcountries, date: "2021-07-04");

  setUp(() {
    apiRepository = MockApiRepository();
    apiBloc = ApiBloc(apiRepository: apiRepository);
  });

  tearDown(() {
    apiBloc?.close();
  });

  test('should assert if full', () {
    expect(() => ApiBloc(apiRepository: null), throwsA(isAssertionError));
  });

  test("Initial state is correct", () {
    expect(apiBloc.initialState, ApiInitState());
  });

  test("Close doesn't emit new state", () {
    expectLater(apiBloc, emitsInOrder([ApiInitState(), emitsDone]));
    apiBloc?.close();
  });

  group("Bloc test", () {
    blocTest("Init, loading and loaded and fetchApi is success", build: () {
      when(apiRepository.fetchFeedList()).thenAnswer(
        (_) => Future.value(covidModel),
      );
    }, act: (bloc) {
      return bloc.add(GetApiList());
    }, expect: {
      [
        ApiInitState(),
        ApiLoading(),
        ApiLoaded(covidModel),
      ]
    });
  });
  blocTest("Init, loading and loaded and fetchApi is failed", build: () {
    when(apiRepository.fetchFeedList())
        .thenThrow(Exception("Error getting quotes"));
  }, act: (bloc) {
    return bloc.add(GetApiList());
  }, expect: {
    [
      ApiInitState(),
      ApiLoading(),
      ApiLoaded(covidModel),
    ]
  });
}
