import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';

class GetUserType {
  final AuthRepository repository;

  GetUserType(this.repository);

  Future<String> call(String uid) {
    return repository.getUserType(uid);
  }
}
