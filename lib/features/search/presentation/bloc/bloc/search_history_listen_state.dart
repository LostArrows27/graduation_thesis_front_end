part of 'search_history_listen_bloc.dart';

@immutable
sealed class SearchHistoryListenState {}

final class SearchHistoryListenInitial extends SearchHistoryListenState {}

final class SearchHistoryListenLoading extends SearchHistoryListenState {}

final class SearchHistoryListenSuccess extends SearchHistoryListenState {
  final List<SearchHistoryItem> searchHistory;

  SearchHistoryListenSuccess({required this.searchHistory});
}

final class SearchHistoryListenFailure extends SearchHistoryListenState {
  final String message;

  SearchHistoryListenFailure({required this.message});
}
