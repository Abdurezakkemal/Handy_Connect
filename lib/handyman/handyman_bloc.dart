import 'dart:async';

import 'models/handyman_profile.dart';
import 'models/request_item.dart';
import 'repositories/handyman_repository.dart';

/// HandymanBloc uses a repository backend. By default it uses the in-memory
/// repository (great for UI preview and tests). You can pass a
/// FirestoreHandymanRepository to connect to Firebase.
class HandymanBloc {
  final HandymanRepository _repo;

  final StreamController<List<RequestItem>> _requestsController =
      StreamController.broadcast();
  final StreamController<HandymanProfile> _profileController =
      StreamController.broadcast();

  Stream<List<RequestItem>> get requestsStream => _requestsController.stream;
  Stream<HandymanProfile> get profileStream => _profileController.stream;

  StreamSubscription<List<RequestItem>>? _reqSub;
  StreamSubscription<HandymanProfile>? _profileSub;

  HandymanBloc({HandymanRepository? repository})
    : _repo = repository ?? InMemoryHandymanRepository() {
    // subscribe to repository streams (handyman id 'me' used for demo)
    _reqSub = _repo
        .requestsStream('me')
        .listen((r) => _requestsController.add(r));
    _profileSub = _repo
        .profileStream('me')
        .listen((p) => _profileController.add(p));
  }

  void initializeSampleData() async {
    // nothing special for repo-based; ensure streams emit initial values
    _repo.addSampleRequest(
      RequestItem(id: 'sample-1', customerName: 'Alice', service: 'Plumbing'),
    );
  }

  Future<void> addSampleRequest(RequestItem r) => _repo.addSampleRequest(r);

  Future<void> saveProfile(HandymanProfile p) async => _repo.saveProfile(p);

  Future<void> updateRequestStatus(String id, RequestStatus status) async =>
      _repo.updateRequestStatus(id, status);

  void dispose() {
    _reqSub?.cancel();
    _profileSub?.cancel();
    _requestsController.close();
    _profileController.close();
    if (_repo is InMemoryHandymanRepository) {
      // close internal controllers if using in-memory repo
      ((_repo as InMemoryHandymanRepository)).dispose();
    }
  }
}
