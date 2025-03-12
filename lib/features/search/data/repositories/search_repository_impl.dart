import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/search/data/datasource/search_history_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/search/data/datasource/search_history_supabase_datasource.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchHistoryRemoteDatasource searchHistoryRemoteDatasource;

  final SearchHistorySupabaseDatasource searchHistorySupabaseDatasource;

  const SearchRepositoryImpl(
      {required this.searchHistoryRemoteDatasource,
      required this.searchHistorySupabaseDatasource});

  @override
  Future<Either<Failure, SearchHistory>> queryImageByText(
      {required String query}) async {
    try {
      final searchHistory =
          await searchHistoryRemoteDatasource.queryImageByText(text: query);
      return right(searchHistory);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> getAllSearchHistory() async {
    try {
      final searchHistoryList =
          await searchHistorySupabaseDatasource.getAllSearchHistory();

      return right(searchHistoryList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  RealtimeChannel listenSearchHistoryChange(
      {required Function(SearchHistoryItem p1) onAddHistory}) {
    return searchHistorySupabaseDatasource.listenSearchHistoryChange(
        onAddHistory: onAddHistory);
  }

  @override
  void unSubcribeToSearchHistoryChannel() {
    searchHistorySupabaseDatasource.unSubcribeToSearchHistoryChannel();
  }

  @override
  Future<Either<Failure, String>> deleteSearchHistoryItem(
      {required String id}) async {
    try {
      final res = await searchHistorySupabaseDatasource.deleteSearchHistory(id);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllSearchHistory() async {
    try {
      await searchHistorySupabaseDatasource.deleteAllSearchHistory();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, SearchHistoryItem>> addSearchHistory(
      {required String content}) async {
    try {
      final searchHistoryItem =
          await searchHistorySupabaseDatasource.addSearchHistory(content);
      return right(searchHistoryItem);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
