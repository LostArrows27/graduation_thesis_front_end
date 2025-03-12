part of 'search_history_bloc.dart';

@immutable
sealed class SearchHistoryEvent {}

final class QueryImageByTextEvent extends SearchHistoryEvent {
  final String query;

  QueryImageByTextEvent({required this.query});
}
