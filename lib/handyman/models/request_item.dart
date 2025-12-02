enum RequestStatus { pending, accepted, rejected }

class RequestItem {
  final String id;
  final String customerName;
  final String service;
  RequestStatus status;

  RequestItem({
    required this.id,
    required this.customerName,
    required this.service,
    this.status = RequestStatus.pending,
  });
}
