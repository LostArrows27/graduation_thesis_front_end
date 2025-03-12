import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';

class SearchHistoryItemModel extends SearchHistoryItem {
  SearchHistoryItemModel(
      {required super.id, required super.createdAt, required super.content});

  factory SearchHistoryItemModel.fromJson(Map<String, dynamic> map) {
    return SearchHistoryItemModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      content: map['content'] as String,
    );
  }
}
