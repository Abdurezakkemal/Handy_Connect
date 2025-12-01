import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';

class GetHandymen {
  final CustomerRepository repository;

  GetHandymen(this.repository);

  Future<List<HandymanUser>> call(String category) {
    return repository.getHandymen(category);
  }
}
