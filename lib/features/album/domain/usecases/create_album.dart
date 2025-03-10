import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/domain/repositories/album_repository.dart';

class CreateAlbum implements UseCase<Album, CreateAlbumParams> {
  final AlbumRepository albumRepository;

  const CreateAlbum({required this.albumRepository});

  @override
  Future<Either<Failure, Album>> call(CreateAlbumParams params) async {
    return await albumRepository.createAlbum(
        name: params.name, imageId: params.imageIdList);
  }
}

class CreateAlbumParams {
  final String name;
  final List<String> imageIdList;

  CreateAlbumParams({required this.name, required this.imageIdList});
}
