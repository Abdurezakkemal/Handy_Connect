import 'dart:io';

import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/customer/domain/models/customer_user.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_customer_profile.dart';
import 'package:handy_connect/features/customer/domain/usecases/update_customer_profile.dart';

part 'customer_profile_event.dart';
part 'customer_profile_state.dart';

class CustomerProfileBloc
    extends Bloc<CustomerProfileEvent, CustomerProfileState> {
  final GetCustomerProfile _getCustomerProfile;
  final UpdateCustomerProfile _updateCustomerProfile;

  CustomerProfileBloc({
    required GetCustomerProfile getCustomerProfile,
    required UpdateCustomerProfile updateCustomerProfile,
  }) : _getCustomerProfile = getCustomerProfile,
       _updateCustomerProfile = updateCustomerProfile,
       super(CustomerProfileInitial()) {
    on<GetCustomerProfileEvent>(_onGetCustomerProfile);
    on<UpdateCustomerProfileEvent>(_onUpdateCustomerProfile);
  }

  Future<void> _onGetCustomerProfile(
    GetCustomerProfileEvent event,
    Emitter<CustomerProfileState> emit,
  ) async {
    emit(CustomerProfileLoading());
    try {
      final customer = await _getCustomerProfile(event.customerId);
      emit(CustomerProfileLoaded(customer));
    } catch (e, stackTrace) {
      developer.log(
        'Error in _onGetCustomerProfile',
        name: 'CustomerProfileBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        CustomerProfileError(e.toString(), error: e, stackTrace: stackTrace),
      );
    }
  }

  Future<void> _onUpdateCustomerProfile(
    UpdateCustomerProfileEvent event,
    Emitter<CustomerProfileState> emit,
  ) async {
    emit(CustomerProfileLoading());
    try {
      await _updateCustomerProfile(event.customer, event.profileImage);
      // After successful update, refetch the latest profile data
      final updatedCustomer = await _getCustomerProfile(event.customer.uid);
      emit(CustomerProfileLoaded(updatedCustomer));
    } catch (e, stackTrace) {
      developer.log(
        'Error in _onUpdateCustomerProfile',
        name: 'CustomerProfileBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        CustomerProfileError(e.toString(), error: e, stackTrace: stackTrace),
      );
    }
  }
}
