part of 'search_history_bloc.dart';

@immutable
sealed class SearchHistoryState {}

final class SearchHistoryInitial extends SearchHistoryState {}

final class SearchHistoryLoading extends SearchHistoryState {}

final class SearchHistoryLoaded extends SearchHistoryState {
  final SearchHistory searchHistory;

  SearchHistoryLoaded({required this.searchHistory});
}

final class SearchHistoryError extends SearchHistoryState {
  final String message;

  SearchHistoryError({required this.message});
}
