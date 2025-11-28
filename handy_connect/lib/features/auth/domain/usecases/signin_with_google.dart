import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<UserCredential> call() async {
    return await repository.signInWithGoogle();
  }
}
