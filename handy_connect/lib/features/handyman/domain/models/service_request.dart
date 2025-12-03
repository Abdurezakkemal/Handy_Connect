import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

    // Helper function to safely convert timestamps
    Timestamp _parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return Timestamp.now();
      if (timestamp is Timestamp) return timestamp;
      if (timestamp is DateTime) return Timestamp.fromDate(timestamp);
      if (timestamp is String) {
        try {
          return Timestamp.fromDate(DateTime.parse(timestamp));
        } catch (e) {
          debugPrint('Error parsing timestamp: $e');
          return Timestamp.now();
        }
      }
      return Timestamp.now();
    }

    return ServiceRequest(
      requestId: doc.id,
      customerId: data['customerId']?.toString() ?? '',
      handymanId: data['handymanId']?.toString() ?? '',
      customerName: data['customerName']?.toString() ?? '',
      issueDescription: data['issueDescription']?.toString() ?? '',
      preferredTime: _parseTimestamp(data['preferredTime']),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == 'RequestStatus.${data['status']}',
        orElse: () => RequestStatus.pending,
      ),
      createdAt: _parseTimestamp(data['createdAt'] ?? data['created_at']),
    );
  }
}
