import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';

class GetVideoSchema implements UseCase<VideoSchema, GetVideoSchemaParams> {
  final VideoRenderRepository videoRenderRepository;

  const GetVideoSchema({required this.videoRenderRepository});

  @override
  Future<Either<Failure, VideoSchema>> call(GetVideoSchemaParams params) async {
    return await videoRenderRepository.uploadImageAndGetVideoSchema(
        offlineImagesList: params.offlineImagesList,
        onlineImageIdList: params.onlineImageIdList,
        userId: params.userId);
  }
}

class GetVideoSchemaParams {
  final List<SelectedImage> offlineImagesList;
  final List<String> onlineImageIdList;
  final String userId;

  GetVideoSchemaParams(
      {required this.offlineImagesList,
      required this.onlineImageIdList,
      required this.userId});
}
