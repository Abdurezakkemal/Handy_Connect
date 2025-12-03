import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';

class UpdateRequestStatus {
  final HandymanRepository repository;

  UpdateRequestStatus(this.repository);

  Future<void> call(String requestId, RequestStatus status) {
    return repository.updateRequestStatus(requestId, status);
  }
}
