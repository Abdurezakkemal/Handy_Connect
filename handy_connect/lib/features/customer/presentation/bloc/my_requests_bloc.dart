import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_my_requests.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

part 'my_requests_event.dart';
part 'my_requests_state.dart';

class MyRequestsBloc extends Bloc<MyRequestsEvent, MyRequestsState> {
  final GetMyRequests _getMyRequests;
  StreamSubscription? _requestsSubscription;

  MyRequestsBloc({required GetMyRequests getMyRequests})
    : _getMyRequests = getMyRequests,
      super(MyRequestsInitial()) {
    on<FetchMyRequests>(_onGetMyRequests);
  }

  void _onGetMyRequests(FetchMyRequests event, Emitter<MyRequestsState> emit) {
    emit(MyRequestsLoading());
    _requestsSubscription?.cancel();
    _requestsSubscription = _getMyRequests
        .call(event.customerId)
        .listen(
          (requests) => emit(MyRequestsLoaded(requests)),
          onError: (error) => emit(MyRequestsError(error.toString())),
        );
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
