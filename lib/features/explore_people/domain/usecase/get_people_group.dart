import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/repositories/explore_repository.dart';

class GetPeopleGroup
    implements UseCase<List<PersonGroup>, NoParams> {
  final ExploreRepository exploreRepository;

  GetPeopleGroup({required this.exploreRepository});

  @override
  Future<Either<Failure, List<PersonGroup>>> call(
      NoParams params) async {
    return await exploreRepository.getPersonGroups();
  }
}
