import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';

class GetAllUserImage implements UseCase<List<Photo>, GetAllUserImageParams> {
  final PhotoRepository photoRepository;

  const GetAllUserImage(this.photoRepository);

  @override
  Future<Either<Failure, List<Photo>>> call(
      GetAllUserImageParams params) async {
    return await photoRepository.getAllUserImage(userId: params.userId);
  }
}

class GetAllUserImageParams {
  final String userId;

  GetAllUserImageParams({required this.userId});
}
