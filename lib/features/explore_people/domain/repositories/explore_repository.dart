import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';

abstract interface class ExploreRepository {
  Future<Either<Failure, List<PersonGroup>>> getPersonGroups();

  Future<Either<Failure, void>> changePersonGroupName(
      {required int clusterId, required String newName});
}
