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
}
