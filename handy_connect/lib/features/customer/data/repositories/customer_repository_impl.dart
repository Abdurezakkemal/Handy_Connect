import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:handy_connect/features/customer/domain/models/customer_user.dart';
import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final FirebaseFirestore _firestore;
  final Dio _dio;

  CustomerRepositoryImpl({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio = dio ?? Dio();

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

  @override
  Future<CustomerUser> getCustomerProfile(String customerId) async {
    final doc = await _firestore.collection('users').doc(customerId).get();
    return CustomerUser.fromFirestore(doc);
  }

  @override
  Future<void> updateCustomerProfile(
    CustomerUser customer,
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

    await _firestore.collection('users').doc(customer.uid).update({
      'name': customer.name,
      'phone': customer.phone,
      'location': customer.location,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
    });
  }
}
