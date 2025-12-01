import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final FirebaseFirestore _firestore;

  CustomerRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<HandymanUser>> getHandymen(String category) async {
    final snapshot = await _firestore
        .collection('users')
        .where('userType', isEqualTo: 'handyman')
        .where('serviceType', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => HandymanUser.fromFirestore(doc)).toList();
  }

  @override
  Future<void> createServiceRequest(ServiceRequest request) async {
    await _firestore.collection('requests').add({
      'customerId': request.customerId,
      'handymanId': request.handymanId,
      'customerName': request.customerName,
      'issueDescription': request.issueDescription,
      'preferredTime': request.preferredTime,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<ServiceRequest>> getMyRequests(String customerId) {
    return _firestore
        .collection('requests')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceRequest.fromFirestore(doc))
              .toList();
        });
  }
}
