import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/repository/photo_repository.dart';

class EditImageCaption implements UseCase<String, EditImageCaptionParams> {
  final PhotoRepository photoRepository;

  const EditImageCaption({required this.photoRepository});

  @override
  Future<Either<Failure, String>> call(EditImageCaptionParams params) async {
    return await photoRepository.editImageCaption(
        caption: params.caption, imageId: params.imageId);
  }
}

class EditImageCaptionParams {
  final String imageId;
  final String caption;

  EditImageCaptionParams({required this.caption, required this.imageId});
}
