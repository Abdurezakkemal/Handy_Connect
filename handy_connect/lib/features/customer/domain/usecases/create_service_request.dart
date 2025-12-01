import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

class CreateServiceRequest {
  final CustomerRepository repository;

  CreateServiceRequest(this.repository);

  Future<void> call(ServiceRequest request) {
    return repository.createServiceRequest(request);
  }
}
