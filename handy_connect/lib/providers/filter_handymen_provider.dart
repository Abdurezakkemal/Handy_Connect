import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/models/handymen_model.dart';
import 'package:handy_connect/services/users_service.dart';

final handymenFilterServiceProvider = Provider((ref) => UsersService());

final contentModuleProvider =
    StreamProvider.family<List<HandymenModel>, String>((ref, service) {
      return ref
          .watch(handymenFilterServiceProvider)
          .getFilteredHandymens(service: service);
    });
