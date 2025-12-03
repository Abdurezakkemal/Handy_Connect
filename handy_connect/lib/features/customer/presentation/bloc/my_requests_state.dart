part of 'my_requests_bloc.dart';

@immutable
abstract class MyRequestsState extends Equatable {
  const MyRequestsState();

  @override
  List<Object> get props => [];
}

class MyRequestsInitial extends MyRequestsState {}

class MyRequestsLoading extends MyRequestsState {}

class MyRequestsLoaded extends MyRequestsState {
  final List<ServiceRequest> requests;

  const MyRequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class MyRequestsError extends MyRequestsState {
  final String message;

  const MyRequestsError(this.message);

  @override
  List<Object> get props => [message];
}
