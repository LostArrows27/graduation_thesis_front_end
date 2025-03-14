import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';

abstract interface class AlbumRepository {
  Future<Either<Failure, Album>> createAlbum(
      {required String name, required List<String> imageId});

  Future<Either<Failure, List<Album>>> getAllAlbums();

  Future<Either<Failure, void>> deleteAlbum({required String albumId});

  Future<Either<Failure, void>> changeAlbumName(
      {required String albumId, required String newName});
}
