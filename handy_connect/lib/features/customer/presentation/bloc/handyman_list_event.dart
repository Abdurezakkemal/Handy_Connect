part of 'handyman_list_bloc.dart';

@immutable
abstract class HandymanListEvent extends Equatable {
  const HandymanListEvent();

  @override
  List<Object> get props => [];
}

class FetchHandymen extends HandymanListEvent {
  final String category;

  const FetchHandymen(this.category);

  @override
  List<Object> get props => [category];
}

class SearchHandymen extends HandymanListEvent {
  final String query;

  const SearchHandymen(this.query);

  @override
  List<Object> get props => [query];
}
