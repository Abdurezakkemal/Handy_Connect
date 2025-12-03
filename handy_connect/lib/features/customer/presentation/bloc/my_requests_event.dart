part of 'my_requests_bloc.dart';

@immutable
abstract class MyRequestsEvent extends Equatable {
  const MyRequestsEvent();

  @override
  List<Object> get props => [];
}

class FetchMyRequests extends MyRequestsEvent {
  final String customerId;

  const FetchMyRequests(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class BackButtonPressed extends MyRequestsEvent {
  const BackButtonPressed();
}
