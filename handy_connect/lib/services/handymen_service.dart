import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_connect/models/requests_model.dart';

class HandymenService {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> sendBookingRequest(RequestsModel request) async {
    await _fireStore.collection("requests").add(request.toJson());
  }

  Future<void> editBookingRequest(RequestsModel request, String id) async {
    await _fireStore.collection('requests').doc(id).update(request.toJson());
  }

  Future<void> deleteBookingRequest(String id) async {
    await _fireStore.collection('requests').doc(id).delete();
  }

  Stream<List<RequestsModel>> fetchBookingRequests({required String userId}) {
    return _fireStore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .where('customerId', isEqualTo: userId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => RequestsModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
