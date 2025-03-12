import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SearchRepository {
  Future<Either<Failure, SearchHistory>> queryImageByText(
      {required String query});

  Future<Either<Failure, List<SearchHistoryItem>>> getAllSearchHistory();

  Future<Either<Failure, String>> deleteSearchHistoryItem({required String id});

  Future<Either<Failure, void>> deleteAllSearchHistory();

  Future<Either<Failure, SearchHistoryItem>> addSearchHistory(
      {required String content});

  void unSubcribeToSearchHistoryChannel();

  RealtimeChannel listenSearchHistoryChange(
      {required Function(SearchHistoryItem) onAddHistory});
}
