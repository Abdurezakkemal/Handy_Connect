import 'dart:io';

import 'package:handy_connect/features/customer/domain/models/customer_user.dart';
import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';

class UpdateCustomerProfile {
  final CustomerRepository repository;

  UpdateCustomerProfile(this.repository);

  Future<void> call(CustomerUser customer, File? profileImage) {
    return repository.updateCustomerProfile(customer, profileImage);
  }
}
