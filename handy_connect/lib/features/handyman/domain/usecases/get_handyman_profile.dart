import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';

class GetHandymanProfile {
  final HandymanRepository repository;

  GetHandymanProfile(this.repository);

  Future<HandymanUser> call(String handymanId) {
    return repository.getHandymanProfile(handymanId);
  }
}
