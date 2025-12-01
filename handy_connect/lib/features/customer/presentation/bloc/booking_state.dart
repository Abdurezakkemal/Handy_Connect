part of 'booking_bloc.dart';

@immutable
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingInProgress extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}
