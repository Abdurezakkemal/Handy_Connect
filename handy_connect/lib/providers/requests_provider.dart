import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/models/requests_model.dart';
import 'package:handy_connect/services/handymen_service.dart';

final requestServiceProvider = Provider<HandymenService>((_) {
  return HandymenService();
});

final getRequestsProvider = StreamProvider.family<List<RequestsModel>, String>((
  ref,
  userId,
) {
  final serviceProvider = ref.watch(requestServiceProvider);
  return serviceProvider.fetchBookingRequests(userId: userId);
});
