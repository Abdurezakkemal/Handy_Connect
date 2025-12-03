import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/customer/domain/usecases/create_service_request.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateServiceRequest _createServiceRequest;

  BookingBloc({required CreateServiceRequest createServiceRequest})
    : _createServiceRequest = createServiceRequest,
      super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingInProgress());
    try {
      await _createServiceRequest(event.request);
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
