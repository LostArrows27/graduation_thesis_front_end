import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/query_image_by_text.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final QueryImageByText _queryImageByText;

  SearchHistoryBloc({required QueryImageByText queryImageByText})
      : _queryImageByText = queryImageByText,
        super(SearchHistoryInitial()) {
    on<SearchHistoryEvent>((event, emit) {});

    on<QueryImageByTextEvent>(_onQueryImageByText);
  }

  void _onQueryImageByText(
      QueryImageByTextEvent event, Emitter<SearchHistoryState> emit) async {
    emit(SearchHistoryLoading());
    final result =
        await _queryImageByText(QueryImageByTextParams(query: event.query));
    result.fold(
      (failure) => emit(SearchHistoryError(message: failure.message)),
      (searchHistory) =>
          emit(SearchHistoryLoaded(searchHistory: searchHistory)),
    );
  }
}
