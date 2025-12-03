import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_handymen.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';

part 'handyman_list_event.dart';
part 'handyman_list_state.dart';

class HandymanListBloc extends Bloc<HandymanListEvent, HandymanListState> {
  final GetHandymen _getHandymen;
  List<HandymanUser> _allHandymen = [];

  HandymanListBloc({required GetHandymen getHandymen})
    : _getHandymen = getHandymen,
      super(HandymanListInitial()) {
    on<FetchHandymen>(_onGetHandymen);
    on<SearchHandymen>(_onSearchHandymen);
  }

  Future<void> _onGetHandymen(
    FetchHandymen event,
    Emitter<HandymanListState> emit,
  ) async {
    emit(HandymanListLoading());
    try {
      final handymen = await _getHandymen(event.category);
      _allHandymen = handymen;
      emit(HandymanListLoaded(handymen));
    } catch (e) {
      emit(HandymanListError(e.toString()));
    }
  }

  void _onSearchHandymen(
    SearchHandymen event,
    Emitter<HandymanListState> emit,
  ) {
    final filteredHandymen = _allHandymen
        .where(
          (handyman) => handyman.location.toLowerCase().contains(
            event.query.toLowerCase(),
          ),
        )
        .toList();
    emit(HandymanListLoaded(filteredHandymen));
  }
}
