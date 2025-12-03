import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/domain/usecases/get_service_requests.dart';
import 'package:handy_connect/features/handyman/domain/usecases/update_request_status.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final GetServiceRequests _getServiceRequests;
  final UpdateRequestStatus _updateRequestStatus;
  StreamSubscription? _requestsSubscription;

  RequestsBloc({
    required GetServiceRequests getServiceRequests,
    required UpdateRequestStatus updateRequestStatus,
  }) : _getServiceRequests = getServiceRequests,
       _updateRequestStatus = updateRequestStatus,
       super(RequestsInitial()) {
    on<GetRequests>(_onGetRequests);
    on<UpdateRequestStatusEvent>(_onUpdateRequestStatus);
  }

  Future<void> _onGetRequests(
    GetRequests event,
    Emitter<RequestsState> emit,
  ) async {
    try {
      emit(RequestsLoading());
      _requestsSubscription?.cancel();

      final requestsStream = _getServiceRequests(event.handymanId);

      await emit.onEach<dynamic>(
        requestsStream,
        onData: (requests) {
          if (!isClosed) {
            emit(RequestsLoaded(requests));
          }
        },
        onError: (error, stackTrace) {
          if (!isClosed) {
            emit(RequestsError(error.toString()));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(RequestsError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateRequestStatus(
    UpdateRequestStatusEvent event,
    Emitter<RequestsState> emit,
  ) async {
    try {
      await _updateRequestStatus(event.requestId, event.status);
    } catch (e) {
      emit(RequestsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
