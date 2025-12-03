import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/auth/domain/usecases/signin.dart';
import 'package:handy_connect/features/auth/domain/usecases/signup.dart';
import 'package:handy_connect/features/auth/domain/usecases/get_user_type.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final SignIn _signIn;
  final GetUserType _getUserType;

  AuthBloc({
    required SignUp signUp,
    required SignIn signIn,
    required GetUserType getUserType,
  }) : _signUp = signUp,
       _signIn = signIn,
       _getUserType = getUserType,
       super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<GetUserTypeRequested>(_onGetUserTypeRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        userType: event.userType,
      );
      if (userCredential.user != null) {
        // First emit the success state
        emit(RegistrationSuccess(userCredential.user!, event.userType));
        // Then reset to initial state to allow future registrations
        emit(AuthInitial());
      } else {
        emit(const AuthError('Sign up failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      // Re-throw the error to be caught by the UI if needed
      rethrow;
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _signIn(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null) {
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Sign in failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetUserTypeRequested(
    GetUserTypeRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final userType = await _getUserType(event.uid);
      if (state is Authenticated) {
        emit(
          AuthenticatedWithUserType((state as Authenticated).user, userType),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
