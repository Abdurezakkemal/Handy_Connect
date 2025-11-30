import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_connect/models/handymen_model.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(HandymenModel handymen) async {
    await _firestore
        .collection("users-info")
        .doc(handymen.id)
        .set(handymen.toJson());
  }

  Future<void> updateUser(HandymenModel handymen) async {
    await _firestore
        .collection("users-info")
        .doc(handymen.id)
        .update(handymen.toJson());
  }

  Future<void> deleteUser(HandymenModel handymen) async {
    await _firestore.collection("users-info").doc(handymen.id).delete();
  }

  Stream<List<HandymenModel>> getFilteredHandymens({required String service}) {
    return _firestore
        .collection("users-info")
        .where('service', isEqualTo: service)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => HandymenModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
