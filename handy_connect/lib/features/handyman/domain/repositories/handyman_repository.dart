import 'dart:io';

import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

abstract class HandymanRepository {
  Stream<List<ServiceRequest>> getServiceRequests(String handymanId);

  Future<HandymanUser> getHandymanProfile(String handymanId);

  Future<void> updateHandymanProfile(HandymanUser handyman, File? profileImage);

  Future<void> updateRequestStatus(String requestId, RequestStatus status);
}
