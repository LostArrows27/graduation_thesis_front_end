import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/album/data/datasource/album_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDatasource albumRemoteDatasource;

  const AlbumRepositoryImpl({required this.albumRemoteDatasource});

  @override
  Future<Either<Failure, Album>> createAlbum(
      {required String name, required List<String> imageId}) async {
    try {
      final album =
          await albumRemoteDatasource.createAlbum(name: name, imageId: imageId);
      return right(album);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Album>>> getAllAlbums() async {
    try {
      final album = await albumRemoteDatasource.getAllAlbums();
      return right(album);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
