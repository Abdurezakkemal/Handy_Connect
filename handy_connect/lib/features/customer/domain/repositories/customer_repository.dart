import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

abstract class CustomerRepository {
  Future<List<HandymanUser>> getHandymen(String category);

  Future<void> createServiceRequest(ServiceRequest request);

  Stream<List<ServiceRequest>> getMyRequests(String customerId);
}
