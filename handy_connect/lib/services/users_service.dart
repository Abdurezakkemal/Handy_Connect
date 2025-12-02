import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_connect/models/user.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User handymen) async {
    await _firestore
        .collection("users")
        .doc(handymen.uid)
        .set(handymen.toJson());
  }

  Future<void> updateUser(User handymen) async {
    await _firestore
        .collection("users")
        .doc(handymen.uid)
        .update(handymen.toJson());
  }

  Future<void> deleteUser(User handymen) async {
    await _firestore.collection("users").doc(handymen.uid).delete();
  }

  Stream<List<User>> filteredHandymensByService({required String service}) {
    return _firestore
        .collection("users")
        .where('serviceType', isEqualTo: service)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => User.fromJson(doc.data())).toList(),
        );
  }

  Stream<User?> filterHandymenById({required String uid}) {
    return _firestore.collection('users').doc(uid).snapshots().map((
      DocumentSnapshot<Map<String, dynamic>> doc,
    ) {
      final data = doc.data();
      return data == null ? null : User.fromJson(data);
    });
  }
}
