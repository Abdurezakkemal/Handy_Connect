part of 'handyman_list_bloc.dart';

@immutable
abstract class HandymanListState extends Equatable {
  const HandymanListState();

  @override
  List<Object> get props => [];
}

class HandymanListInitial extends HandymanListState {}

class HandymanListLoading extends HandymanListState {}

class HandymanListLoaded extends HandymanListState {
  final List<HandymanUser> handymen;

  const HandymanListLoaded(this.handymen);

  @override
  List<Object> get props => [handymen];
}

class HandymanListError extends HandymanListState {
  final String message;

  const HandymanListError(this.message);

  @override
  List<Object> get props => [message];
}
