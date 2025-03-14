import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';

class ChangeAlbumName implements UseCase<void, ChangeAlbumNameParams> {
  final AlbumRepository albumRepository;

  const ChangeAlbumName({required this.albumRepository});

  @override
  Future<Either<Failure, void>> call(ChangeAlbumNameParams params) async {
    return await albumRepository.changeAlbumName(
        albumId: params.albumId, newName: params.newName);
  }
}

class ChangeAlbumNameParams {
  final String albumId;
  final String newName;

  const ChangeAlbumNameParams({required this.albumId, required this.newName});
}
