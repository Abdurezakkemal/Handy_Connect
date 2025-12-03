part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticatedWithUserType extends AuthState {
  final User user;
  final String userType;

  const AuthenticatedWithUserType(this.user, this.userType);

  @override
  List<Object> get props => [user, userType];
}

class RegistrationSuccess extends AuthState {
  final User user;
  final UserType userType;

  const RegistrationSuccess(this.user, this.userType);

  @override
  List<Object> get props => [user, userType];
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
