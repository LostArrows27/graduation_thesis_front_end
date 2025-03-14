import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/photo/data/datasource/photo_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource photoRemoteDataSource;

  const PhotoRepositoryImpl({
    required this.photoRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Photo>>> getAllUserImage(
      {required String userId}) async {
    try {
      final imageLists =
          await photoRemoteDataSource.getAllUserImage(userId: userId);

      return right(imageLists);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> editImageCaption(
      {required String caption, required String imageId}) async {
    try {
      final res = await photoRemoteDataSource.editImageCaption(
        caption: caption,
        imageId: imageId,
      );

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(
      {required String imageBucketId, required String imageName}) async {
    try {
      await photoRemoteDataSource.deleteImage(
        imageBucketId: imageBucketId,
        imageName: imageName,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> favoriteImage(
      {required String imageId, required bool isFavorite}) async {
    try {
      await photoRemoteDataSource.favoriteImage(
        imageId: imageId,
        isFavorite: isFavorite,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
