import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history.dart';

class SearchHistoryModel extends SearchHistory {
  SearchHistoryModel({required super.searchHistoryId, required super.result});

  factory SearchHistoryModel.fromJson(Map<String, dynamic> map) {
    return SearchHistoryModel(
      searchHistoryId: map['search_history_id'] as String,
      result: List<SearchResult>.from(
        (map['result'] as List<dynamic>).map<SearchResult>(
          (x) => SearchResult.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
