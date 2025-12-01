import 'dart:io';

import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';

class UpdateHandymanProfile {
  final HandymanRepository repository;

  UpdateHandymanProfile(this.repository);

  Future<void> call(HandymanUser handyman, File? profileImage) {
    return repository.updateHandymanProfile(handyman, profileImage);
  }
}
