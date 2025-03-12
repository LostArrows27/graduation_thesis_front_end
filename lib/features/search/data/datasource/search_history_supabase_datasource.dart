import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/search/data/model/search_history_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SearchHistorySupabaseDatasource {
  Future<List<SearchHistoryItemModel>> getAllSearchHistory();

  RealtimeChannel listenSearchHistoryChange(
      {required Function(SearchHistoryItemModel) onAddHistory});

  Future<SearchHistoryItemModel> addSearchHistory(String content);

  Future<String> deleteSearchHistory(String id);

  Future<void> deleteAllSearchHistory();

  void unSubcribeToSearchHistoryChannel();
}

class SearchHistorySupabaseDatasourceImpl
    implements SearchHistorySupabaseDatasource {
  final SupabaseClient supabaseClient;

  SearchHistorySupabaseDatasourceImpl({required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  RealtimeChannel listenSearchHistoryChange(
      {required Function(SearchHistoryItemModel) onAddHistory}) {
    return supabaseClient
        .channel('search_history:$userId')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'search_history',
            callback: (payload) async {
              if (payload.eventType == PostgresChangeEvent.insert) {
                final data = payload.newRecord;
                SearchHistoryItemModel newSchema =
                    SearchHistoryItemModel.fromJson(data);
                onAddHistory(newSchema);
              }
            },
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: userId))
        .subscribe();
  }

  @override
  void unSubcribeToSearchHistoryChannel() {
    supabaseClient.channel('search_history:$userId').unsubscribe();
  }

  @override
  Future<List<SearchHistoryItemModel>> getAllSearchHistory() async {
    try {
      final res = await supabaseClient
          .from('search_history')
          .select('id, created_at, content')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return res.map((e) => SearchHistoryItemModel.fromJson(e)).toList();
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to get video chunks');
    }
  }

  @override
  Future<String> deleteSearchHistory(String id) async {
    try {
      await supabaseClient.from('search_history').delete().eq('id', id);

      return id;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to delete search history');
    }
  }

  @override
  Future<void> deleteAllSearchHistory() async {
    try {
      await supabaseClient
          .from('search_history')
          .delete()
          .eq('user_id', userId);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to delete all search history');
    }
  }

  @override
  Future<SearchHistoryItemModel> addSearchHistory(String content) async {
    try {
      final res = await supabaseClient
          .from('search_history')
          .insert({
            'user_id': userId,
            'content': content,
          })
          .select()
          .single();

      return SearchHistoryItemModel.fromJson(res);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to add search history');
    }
  }
}
