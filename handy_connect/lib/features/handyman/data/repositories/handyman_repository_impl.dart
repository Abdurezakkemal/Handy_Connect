import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';

class HandymanRepositoryImpl implements HandymanRepository {
  final FirebaseFirestore _firestore;
  final Dio _dio;

  HandymanRepositoryImpl({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio = dio ?? Dio();

  @override
  Stream<List<ServiceRequest>> getServiceRequests(String handymanId) {
    return _firestore
        .collection('requests')
        .where('handymanId', isEqualTo: handymanId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceRequest.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<HandymanUser> getHandymanProfile(String handymanId) async {
    final doc = await _firestore.collection('users').doc(handymanId).get();
    return HandymanUser.fromFirestore(doc);
  }

  @override
  Future<void> updateHandymanProfile(
    HandymanUser handyman,
    File? profileImage,
  ) async {
    String? profilePhotoUrl;
    if (profileImage != null) {
      const dbName = "dvdeyvf5i";
      const url = "https://api.cloudinary.com/v1_1/$dbName/image/upload";
      final formData = FormData.fromMap({
        'upload_preset': "handy_connect",
        'file': await MultipartFile.fromFile(profileImage.path),
        'folder': 'profile_photos',
      });

      try {
        final response = await _dio.post(url, data: formData);

        if (response.statusCode == 200) {
          profilePhotoUrl = response.data['secure_url'];
        } else {
          throw Exception("Upload failed: ${response.statusMessage}");
        }
      } on DioException catch (e) {
        throw Exception("Dio error: ${e.response?.data ?? e.message}");
      }
    }

    await _firestore.collection('users').doc(handyman.uid).update({
      'name': handyman.name,
      'phone': handyman.phone,
      'location': handyman.location,
      'serviceType': handyman.serviceType,
      'description': handyman.description,
      'experience': handyman.experience,
      'socialLinks': handyman.socialLinks,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
    });
  }

  @override
  Future<void> updateRequestStatus(
    String requestId,
    RequestStatus status,
  ) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': status.toString().split('.').last,
    });
  }
}
