import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/usecases/get_handyman_profile.dart';
import 'package:handy_connect/features/handyman/domain/usecases/update_handyman_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetHandymanProfile _getHandymanProfile;
  final UpdateHandymanProfile _updateHandymanProfile;

  ProfileBloc({
    required GetHandymanProfile getHandymanProfile,
    required UpdateHandymanProfile updateHandymanProfile,
  }) : _getHandymanProfile = getHandymanProfile,
       _updateHandymanProfile = updateHandymanProfile,
       super(ProfileInitial()) {
    on<GetProfile>(_onGetProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final handyman = await _getHandymanProfile(event.handymanId);
      emit(ProfileLoaded(handyman));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _updateHandymanProfile(event.handyman, event.profileImage);
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
