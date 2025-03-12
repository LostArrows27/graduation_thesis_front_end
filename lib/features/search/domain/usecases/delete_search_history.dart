import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';

class DeleteSearchHistory
    implements UseCase<String, DeleteSearchHistoryParams> {
  final SearchRepository searchRepository;

  const DeleteSearchHistory({required this.searchRepository});

  @override
  Future<Either<Failure, String>> call(DeleteSearchHistoryParams params) async {
    return await searchRepository.deleteSearchHistoryItem(id: params.id);
  }
}

class DeleteSearchHistoryParams {
  final String id;

  DeleteSearchHistoryParams({required this.id});
}
