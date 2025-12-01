import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';

class GetServiceRequests {
  final HandymanRepository repository;

  GetServiceRequests(this.repository);

  Stream<List<ServiceRequest>> call(String handymanId) {
    return repository.getServiceRequests(handymanId);
  }
}
