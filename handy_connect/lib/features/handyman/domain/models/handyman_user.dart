import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HandymanUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String profilePhotoUrl;
  final Map<String, String> socialLinks;
  final String serviceType;
  final String description;
  final String experience;

  const HandymanUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.profilePhotoUrl,
    required this.socialLinks,
    required this.serviceType,
    required this.description,
    required this.experience,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    location,
    profilePhotoUrl,
    socialLinks,
    serviceType,
    description,
    experience,
  ];

  factory HandymanUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HandymanUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
      socialLinks: Map<String, String>.from(data['socialLinks'] ?? {}),
      serviceType: data['serviceType'] ?? '',
      description: data['description'] ?? '',
      experience: data['experience'] ?? '',
    );
  }
}
