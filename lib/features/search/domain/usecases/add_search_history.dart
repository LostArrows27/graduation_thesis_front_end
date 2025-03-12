import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';

class AddSearchHistory
    implements UseCase<SearchHistoryItem, AddSearchHistoryParams> {
  final SearchRepository searchRepository;

  const AddSearchHistory({required this.searchRepository});

  @override
  Future<Either<Failure, SearchHistoryItem>> call(
      AddSearchHistoryParams params) async {
    return await searchRepository.addSearchHistory(content: params.query);
  }
}

class AddSearchHistoryParams {
  final String query;

  AddSearchHistoryParams({required this.query});
}
