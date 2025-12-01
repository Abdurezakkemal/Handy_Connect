part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfile extends ProfileEvent {
  final String handymanId;

  const GetProfile(this.handymanId);

  @override
  List<Object> get props => [handymanId];
}

class UpdateProfile extends ProfileEvent {
  final HandymanUser handyman;
  final File? profileImage;

  const UpdateProfile(this.handyman, this.profileImage);

  @override
  List<Object?> get props => [handyman, profileImage];
}
