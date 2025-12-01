import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'userType': userType.toString().split('.').last,
        'location': '', // To be updated later
        'socialLinks': {},
        'profilePhoto': '',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in signUp: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Unknown error in signUp: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in signIn: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Unknown error in signIn: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google Sign in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'userType': 'customer', // Default to customer
          'location': '',
          'socialLinks': {},
          'profilePhoto': userCredential.user!.photoURL,
        });
      }

      return userCredential;
    } catch (e) {
      print('Unknown error in signInWithGoogle: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Future<String> getUserType(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['userType'] ?? 'customer';
  }
}
