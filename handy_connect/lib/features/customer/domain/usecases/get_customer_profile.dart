import 'package:handy_connect/features/customer/domain/models/customer_user.dart';
import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';

class GetCustomerProfile {
  final CustomerRepository repository;

  GetCustomerProfile(this.repository);

  Future<CustomerUser> call(String customerId) {
    return repository.getCustomerProfile(customerId);
  }
}
