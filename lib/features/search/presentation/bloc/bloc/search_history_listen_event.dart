part of 'search_history_listen_bloc.dart';

@immutable
sealed class SearchHistoryListenEvent {}

final class FetchAllSearchHistory extends SearchHistoryListenEvent {}

final class ListenSearchHistoryChange extends SearchHistoryListenEvent {}

final class UnListenSearchHistoryChange extends SearchHistoryListenEvent {}

final class SearchHistoryUpdate extends SearchHistoryListenEvent {
  final List<SearchHistoryItem> updatedSearchHistory;

  SearchHistoryUpdate({required this.updatedSearchHistory});
}

final class DeleteSearchHistoryEvent extends SearchHistoryListenEvent {
  final String id;

  DeleteSearchHistoryEvent({required this.id});
}

final class DeleteAllSearchHistoryEvent extends SearchHistoryListenEvent {}

final class AddSearchHistoryEvent extends SearchHistoryListenEvent {
  final String content;

  AddSearchHistoryEvent({required this.content});
}
