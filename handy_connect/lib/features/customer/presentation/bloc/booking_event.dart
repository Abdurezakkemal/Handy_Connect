part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final ServiceRequest request;

  const CreateBooking(this.request);

  @override
  List<Object> get props => [request];
}
