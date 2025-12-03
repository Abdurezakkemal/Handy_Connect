part of 'customer_profile_bloc.dart';

@immutable
abstract class CustomerProfileEvent extends Equatable {
  const CustomerProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomerProfileEvent extends CustomerProfileEvent {
  final String customerId;

  const GetCustomerProfileEvent(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class UpdateCustomerProfileEvent extends CustomerProfileEvent {
  final CustomerUser customer;
  final File? profileImage;

  const UpdateCustomerProfileEvent(this.customer, this.profileImage);

  @override
  List<Object?> get props => [customer, profileImage];
}
