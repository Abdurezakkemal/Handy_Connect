import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/handyman_profile.dart';
import '../models/request_item.dart';
import 'handyman_repository.dart';

class FirestoreHandymanRepository implements HandymanRepository {
  final FirebaseFirestore _db;

  FirestoreHandymanRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<RequestItem>> requestsStream(String handymanId) {
    return _db
        .collection('requests')
        .where('handymanId', isEqualTo: handymanId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => _fromDoc(d)).toList());
  }

  RequestItem _fromDoc(QueryDocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>;
    final statusStr = data['status'] as String? ?? 'pending';
    return RequestItem(
      id: d.id,
      customerName: data['customerName'] as String? ?? 'Unknown',
      service: data['service'] as String? ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == statusStr,
        orElse: () => RequestStatus.pending,
      ),
    );
  }

  @override
  Stream<HandymanProfile> profileStream(String handymanId) {
    return _db.collection('handymen').doc(handymanId).snapshots().map((doc) {
      final data = doc.data() ?? <String, dynamic>{};
      return HandymanProfile(
        id: doc.id,
        fullName: data['fullName'] as String? ?? '',
        phoneNumber: data['phoneNumber'] as String? ?? '',
        whatsappNumber: data['whatsappNumber'] as String? ?? '',
        username: data['username'] as String? ?? '',
        serviceType: data['serviceType'] as String? ?? '',
        location: data['location'] as String? ?? '',
        description: data['description'] as String? ?? '',
      );
    });
  }

  @override
  Future<void> saveProfile(HandymanProfile profile) async {
    await _db.collection('handymen').doc(profile.id).set({
      'fullName': profile.fullName,
      'phoneNumber': profile.phoneNumber,
      'whatsappNumber': profile.whatsappNumber,
      'username': profile.username,
      'serviceType': profile.serviceType,
      'location': profile.location,
      'description': profile.description,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateRequestStatus(
    String requestId,
    RequestStatus status,
  ) async {
    await _db.collection('requests').doc(requestId).update({
      'status': status.toString().split('.').last,
    });
  }

  @override
  Future<void> addSampleRequest(RequestItem req) async {
    await _db.collection('requests').add({
      'customerName': req.customerName,
      'service': req.service,
      'handymanId': 'me',
      'status': req.status.toString().split('.').last,
    });
  }
}
