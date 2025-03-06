import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/repositories/explore_repository.dart';

class ChangePersonGroupName
    implements UseCase<void, ChangePersonGroupNameParams> {
  final ExploreRepository exploreRepository;

  ChangePersonGroupName({required this.exploreRepository});

  @override
  Future<Either<Failure, void>> call(ChangePersonGroupNameParams params) async {
    return await exploreRepository.changePersonGroupName(
        clusterId: params.clusterId, newName: params.newName);
  }
}

class ChangePersonGroupNameParams {
  final int clusterId;
  final String newName;

  ChangePersonGroupNameParams({required this.clusterId, required this.newName});
}
