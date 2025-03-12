import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';

class DeleteAllSearchHistory implements UseCase<void, NoParams> {
  final SearchRepository searchRepository;

  const DeleteAllSearchHistory({required this.searchRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await searchRepository.deleteAllSearchHistory();
  }
}
