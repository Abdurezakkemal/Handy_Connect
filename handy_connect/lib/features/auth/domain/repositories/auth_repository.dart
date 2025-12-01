import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';

abstract class AuthRepository {
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
  });

  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> signOut();

  Future<String> getUserType(String uid);
}
