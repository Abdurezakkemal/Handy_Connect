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
    on<BackButtonPressed>(_onBackButtonPressed);
  }

  void _onBackButtonPressed(
    BackButtonPressed event,
    Emitter<MyRequestsState> emit,
  ) {
    // This will be handled by the UI to navigate back
    // The BLoC doesn't need to do anything special here
  }

  Future<void> _onGetMyRequests(
    FetchMyRequests event,
    Emitter<MyRequestsState> emit,
  ) async {
    try {
      emit(MyRequestsLoading());
      _requestsSubscription?.cancel();

      final requestsStream = _getMyRequests.call(event.customerId);

      await emit.onEach<dynamic>(
        requestsStream,
        onData: (requests) {
          if (!isClosed) {
            emit(MyRequestsLoaded(requests));
          }
        },
        onError: (error, stackTrace) {
          if (!isClosed) {
            emit(MyRequestsError(error.toString()));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(MyRequestsError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
