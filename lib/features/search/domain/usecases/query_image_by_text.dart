import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/search/domain/entities/search_history.dart';
import 'package:graduation_thesis_front_end/features/search/domain/repositories/search_repository.dart';

class QueryImageByText
    implements UseCase<SearchHistory, QueryImageByTextParams> {
  final SearchRepository searchRepository;

  const QueryImageByText({required this.searchRepository});

  @override
  Future<Either<Failure, SearchHistory>> call(
      QueryImageByTextParams params) async {
    return await searchRepository.queryImageByText(query: params.query);
  }
}

class QueryImageByTextParams {
  final String query;

  QueryImageByTextParams({required this.query});
}
