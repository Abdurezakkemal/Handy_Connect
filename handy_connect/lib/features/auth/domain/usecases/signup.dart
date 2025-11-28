import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<UserCredential> call({
    required String name,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    return await repository.signUp(
      name: name,
      email: email,
      password: password,
      userType: userType,
    );
  }
}
