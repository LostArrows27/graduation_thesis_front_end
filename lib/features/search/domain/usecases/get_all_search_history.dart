import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history_item.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';

class GetAllSearchHistory
    implements UseCase<List<SearchHistoryItem>, NoParams> {
  final SearchRepository searchRepository;

  const GetAllSearchHistory({required this.searchRepository});

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> call(NoParams params) async {
    return await searchRepository.getAllSearchHistory();
  }
}
