import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';

class GetAllAlbum implements UseCase<List<Album>, NoParams> {
  final AlbumRepository albumRepository;

  const GetAllAlbum({required this.albumRepository});

  @override
  Future<Either<Failure, List<Album>>> call(NoParams params) async {
    return await albumRepository.getAllAlbums();
  }
}
