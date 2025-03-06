import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/datasource/people_category_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/explore_people/data/datasource/person_group_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final PeopleCategoryRemoteDatasource peopleCategoryRemoteDatasource;
  final PersonGroupRemoteDatasource personGroupRemoteDatasource;

  ExploreRepositoryImpl(
      {required this.peopleCategoryRemoteDatasource,
      required this.personGroupRemoteDatasource});

  @override
  Future<Either<Failure, List<PersonGroup>>> getPersonGroups() async {
    try {
      final personGroups =
          await peopleCategoryRemoteDatasource.getPersonGroups();
      return right(personGroups);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePersonGroupName(
      {required int clusterId, required String newName}) async {
    try {
      await personGroupRemoteDatasource.changePersonGroupName(
          clusterId: clusterId, newName: newName);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
