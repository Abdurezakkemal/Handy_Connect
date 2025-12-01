part of 'requests_bloc.dart';

@immutable
abstract class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object> get props => [];
}

class GetRequests extends RequestsEvent {
  final String handymanId;

  const GetRequests(this.handymanId);

  @override
  List<Object> get props => [handymanId];
}

class UpdateRequestStatusEvent extends RequestsEvent {
  final String requestId;
  final RequestStatus status;

  const UpdateRequestStatusEvent(this.requestId, this.status);

  @override
  List<Object> get props => [requestId, status];
}
