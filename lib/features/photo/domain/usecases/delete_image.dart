import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';

class DeleteImage implements UseCase<void, DeleteImageParams> {
  final PhotoRepository photoRepository;

  const DeleteImage({required this.photoRepository});

  @override
  Future<Either<Failure, void>> call(DeleteImageParams params) async {
    return await photoRepository.deleteImage(
        imageBucketId: params.imageBucketId, imageName: params.imageName);
  }
}

class DeleteImageParams {
  final String imageBucketId;
  final String imageName;

  const DeleteImageParams(
      {required this.imageBucketId, required this.imageName});
}
