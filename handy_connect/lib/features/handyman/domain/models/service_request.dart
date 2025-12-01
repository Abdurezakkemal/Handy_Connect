import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum RequestStatus { pending, accepted, rejected }

class ServiceRequest extends Equatable {
  final String requestId;
  final String customerId;
  final String handymanId;
  final String customerName;
  final String issueDescription;
  final Timestamp preferredTime;
  final RequestStatus status;
  final Timestamp createdAt;

  const ServiceRequest({
    required this.requestId,
    required this.customerId,
    required this.handymanId,
    required this.customerName,
    required this.issueDescription,
    required this.preferredTime,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    requestId,
    customerId,
    handymanId,
    customerName,
    issueDescription,
    preferredTime,
    status,
    createdAt,
  ];

  factory ServiceRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceRequest(
      requestId: doc.id,
      customerId: data['customerId'] ?? '',
      handymanId: data['handymanId'] ?? '',
      customerName: data['customerName'] ?? '',
      issueDescription: data['issueDescription'] ?? '',
      preferredTime: data['preferredTime'] ?? Timestamp.now(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == 'RequestStatus.${data['status']}',
        orElse: () => RequestStatus.pending,
      ),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
