import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

class GetMyRequests {
  final CustomerRepository repository;

  GetMyRequests(this.repository);

  Stream<List<ServiceRequest>> call(String customerId) {
    return repository.getMyRequests(customerId);
  }
}
