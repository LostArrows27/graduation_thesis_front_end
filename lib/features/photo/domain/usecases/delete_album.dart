import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';

class DeleteAlbum implements UseCase<void, DeleteAlbumParams> {
  final AlbumRepository albumRepository;

  const DeleteAlbum({required this.albumRepository});

  @override
  Future<Either<Failure, void>> call(DeleteAlbumParams params) async {
    return await albumRepository.deleteAlbum(albumId: params.albumId);
  }
}

class DeleteAlbumParams {
  final String albumId;

  const DeleteAlbumParams({required this.albumId});
}
