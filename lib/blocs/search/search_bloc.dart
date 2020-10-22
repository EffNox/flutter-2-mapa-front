import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapas/models/search_result.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent ev) async* {
    if (ev is OnActiveMarkManual) {
      yield state.copyWith(selectManual: !state.selectManual);
    } else if (ev is OnAddHistory) {
      final exists = state.history
          .where((e) => e.position.latitude == ev.result.position.latitude)
          .length;
      if (exists == 0)
        yield state.copyWith(history: [...state.history, ev.result]);
        
    }
  }
}
