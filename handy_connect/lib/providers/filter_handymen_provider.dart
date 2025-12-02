import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/models/user.dart';
import 'package:handy_connect/services/users_service.dart';

final handymenFilterServiceProvider = Provider((ref) => UsersService());

final filterHandymensProvider = StreamProvider.family<List<User>, String>((
  ref,
  service,
) {
  return ref
      .watch(handymenFilterServiceProvider)
      .filteredHandymensByService(service: service);
});

final filterHandymenByIdProvider = StreamProvider.family<User?, String>((
  ref,
  uid,
) {
  return ref.watch(handymenFilterServiceProvider).filterHandymenById(uid: uid);
});
