part of 'api_bloc.dart';

@immutable
abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object> get props => [];
}

class ApiInitState extends ApiState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ApiLoading extends ApiState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ApiLoaded extends ApiState {
  final CovidModel covidModel;
  const ApiLoaded(this.covidModel) : assert(covidModel != null);
  @override
  // TODO: implement props
  List<Object> get props => [covidModel];
}

class ApiError extends ApiState {
  final String message;
  const ApiError(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
