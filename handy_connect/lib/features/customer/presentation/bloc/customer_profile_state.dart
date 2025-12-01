part of 'customer_profile_bloc.dart';

@immutable
abstract class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object> get props => [];
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileLoaded extends CustomerProfileState {
  final CustomerUser customer;

  const CustomerProfileLoaded(this.customer);

  @override
  List<Object> get props => [customer];
}

class CustomerProfileUpdateSuccess extends CustomerProfileState {}

class CustomerProfileError extends CustomerProfileState {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const CustomerProfileError(this.message, {this.error, this.stackTrace});

  @override
  List<Object> get props => [message, if (error != null) error];

  @override
  String toString() => 'CustomerProfileError(message: $message, error: $error)';
}
