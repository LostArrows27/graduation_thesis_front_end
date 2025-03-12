import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/add_search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/delete_search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/usecases/get_all_search_history.dart';

part 'search_history_listen_event.dart';
part 'search_history_listen_state.dart';

class SearchHistoryListenBloc
    extends Bloc<SearchHistoryListenEvent, SearchHistoryListenState> {
  final GetAllSearchHistory _getAllSearchHistory;
  final SearchRepository _searchRepository;
  final DeleteSearchHistory _deleteSearchHistory;
  final AddSearchHistory _addSearchHistory;

  SearchHistoryListenBloc(
      {required GetAllSearchHistory getAllSearchHistory,
      required SearchRepository searchRepository,
      required DeleteSearchHistory deleteSearchHistory,
      required AddSearchHistory addSearchHistory})
      : _getAllSearchHistory = getAllSearchHistory,
        _searchRepository = searchRepository,
        _deleteSearchHistory = deleteSearchHistory,
        _addSearchHistory = addSearchHistory,
        super(SearchHistoryListenInitial()) {
    on<SearchHistoryListenEvent>((event, emit) {});

    on<FetchAllSearchHistory>(_onFetchAllSearchHistory);

    on<ListenSearchHistoryChange>(_onListenSearchHistoryChange);

    on<UnListenSearchHistoryChange>(_onUnListenSearchHistoryChange);

    on<SearchHistoryUpdate>(_onSearchHistoryUpdate);

    on<DeleteSearchHistoryEvent>(_onSearchHistoryDelete);

    on<DeleteAllSearchHistoryEvent>(_onDeleteAllSearchHistory);

    on<AddSearchHistoryEvent>(_onAddSearchHistory);
  }

  void _onFetchAllSearchHistory(
    FetchAllSearchHistory event,
    Emitter<SearchHistoryListenState> emit,
  ) async {
    emit(SearchHistoryListenLoading());
    final res = await _getAllSearchHistory(NoParams());

    res.fold(
      (l) => emit(SearchHistoryListenFailure(message: l.message)),
      (r) => emit(SearchHistoryListenSuccess(searchHistory: r)),
    );
  }

  void _onListenSearchHistoryChange(
    ListenSearchHistoryChange event,
    Emitter<SearchHistoryListenState> emit,
  ) {
    _searchRepository.listenSearchHistoryChange(onAddHistory: (addedHistory) {
      if (state is SearchHistoryListenSuccess) {
        final currentState = state as SearchHistoryListenSuccess;
        return add(SearchHistoryUpdate(
            updatedSearchHistory: currentState.searchHistory
              ..insert(0, addedHistory)));
      }
    });
  }

  void _onUnListenSearchHistoryChange(
    UnListenSearchHistoryChange event,
    Emitter<SearchHistoryListenState> emit,
  ) {
    _searchRepository.unSubcribeToSearchHistoryChannel();
  }

  void _onSearchHistoryUpdate(
    SearchHistoryUpdate event,
    Emitter<SearchHistoryListenState> emit,
  ) {
    emit(SearchHistoryListenSuccess(searchHistory: event.updatedSearchHistory));
  }

  void _onSearchHistoryDelete(
    DeleteSearchHistoryEvent event,
    Emitter<SearchHistoryListenState> emit,
  ) async {
    final res =
        await _deleteSearchHistory(DeleteSearchHistoryParams(id: event.id));

    res.fold((l) => emit(SearchHistoryListenFailure(message: l.message)), (r) {
      if (state is SearchHistoryListenSuccess) {
        final currentState = state as SearchHistoryListenSuccess;
        emit(SearchHistoryListenSuccess(
            searchHistory: currentState.searchHistory
              ..removeWhere((element) => element.id == event.id)));
      }
    });
  }

  void _onDeleteAllSearchHistory(
    DeleteAllSearchHistoryEvent event,
    Emitter<SearchHistoryListenState> emit,
  ) async {
    final res = await _searchRepository.deleteAllSearchHistory();

    res.fold((l) => emit(SearchHistoryListenFailure(message: l.message)),
        (r) => emit(SearchHistoryListenSuccess(searchHistory: [])));
  }

  void _onAddSearchHistory(
    AddSearchHistoryEvent event,
    Emitter<SearchHistoryListenState> emit,
  ) async {
    final res =
        await _addSearchHistory(AddSearchHistoryParams(query: event.content));

    res.fold((l) => emit(SearchHistoryListenFailure(message: l.message)), (r) {
      if (state is SearchHistoryListenSuccess) {
        final currentState = state as SearchHistoryListenSuccess;
        emit(SearchHistoryListenSuccess(
            searchHistory: currentState.searchHistory));
      }
    });
  }
}
