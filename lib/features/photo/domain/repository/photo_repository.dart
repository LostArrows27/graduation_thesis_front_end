import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';

abstract interface class PhotoRepository {
  Future<Either<Failure, List<Photo>>> getAllUserImage({
    required String userId,
  });

  Future<Either<Failure, String>> editImageCaption({
    required String caption,
    required String imageId,
  });

  Future<Either<Failure, void>> deleteImage({
    required String imageBucketId,
    required String imageName,
  });

  Future<Either<Failure, void>> favoriteImage({
    required String imageId,
    required bool isFavorite,
  });
}
