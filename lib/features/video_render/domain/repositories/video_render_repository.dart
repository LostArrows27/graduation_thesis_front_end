import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';

abstract interface class VideoRenderRepository {
  Future<Either<Failure, VideoSchema>> uploadImageAndGetVideoSchema(
      {required List<SelectedImage> offlineImagesList,
      required List<String> onlineImageIdList,
      required String userId});
}
