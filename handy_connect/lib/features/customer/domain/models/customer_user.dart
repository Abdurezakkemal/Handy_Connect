import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CustomerUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String profilePhotoUrl;

  const CustomerUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    location,
    profilePhotoUrl,
  ];

  factory CustomerUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomerUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
    );
  }
}
