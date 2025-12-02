import 'dart:async';

import '../models/handyman_profile.dart';
import '../models/request_item.dart';

abstract class HandymanRepository {
  Stream<List<RequestItem>> requestsStream(String handymanId);
  Stream<HandymanProfile> profileStream(String handymanId);

  Future<void> saveProfile(HandymanProfile profile);

  Future<void> updateRequestStatus(String requestId, RequestStatus status);

  /// Optional helpers for tests and local use
  Future<void> addSampleRequest(RequestItem req) async {}
}

/// In-memory implementation for tests and local preview.
class InMemoryHandymanRepository implements HandymanRepository {
  final HandymanProfile profile = HandymanProfile(id: 'me');
  final List<RequestItem> _requests = [];

  final StreamController<List<RequestItem>> _requestsController =
      StreamController.broadcast();
  final StreamController<HandymanProfile> _profileController =
      StreamController.broadcast();

  InMemoryHandymanRepository() {
    _emitRequests();
    _emitProfile();
  }

  @override
  Stream<List<RequestItem>> requestsStream(String handymanId) =>
      _requestsController.stream;

  @override
  Stream<HandymanProfile> profileStream(String handymanId) =>
      _profileController.stream;

  @override
  Future<void> addSampleRequest(RequestItem req) async {
    _requests.add(req);
    _emitRequests();
  }

  @override
  Future<void> saveProfile(HandymanProfile profile) async {
    this.profile.fullName = profile.fullName;
    this.profile.phoneNumber = profile.phoneNumber;
    this.profile.whatsappNumber = profile.whatsappNumber;
    this.profile.username = profile.username;
    this.profile.serviceType = profile.serviceType;
    this.profile.location = profile.location;
    this.profile.description = profile.description;
    await Future.delayed(const Duration(milliseconds: 200));
    _emitProfile();
  }

  @override
  Future<void> updateRequestStatus(
    String requestId,
    RequestStatus status,
  ) async {
    final i = _requests.indexWhere((r) => r.id == requestId);
    if (i >= 0) {
      _requests[i].status = status;
      await Future.delayed(const Duration(milliseconds: 150));
      _emitRequests();
    }
  }

  void _emitRequests() => _requestsController.add(List.unmodifiable(_requests));
  void _emitProfile() => _profileController.add(profile);

  void dispose() {
    _requestsController.close();
    _profileController.close();
  }
}
