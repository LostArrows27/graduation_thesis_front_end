import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';

class EditVideoSchema implements UseCase<VideoSchema, EditVideoSchemaParams> {
  final VideoRenderRepository videoRenderRepository;

  const EditVideoSchema({required this.videoRenderRepository});

  @override
  Future<Either<Failure, VideoSchema>> call(
      EditVideoSchemaParams params) async {
    return await videoRenderRepository.editVideoSchema(
        videoSchema: params.videoSchema, scale: params.scale);
  }
}

class EditVideoSchemaParams {
  final VideoSchema videoSchema;
  final String scale;

  EditVideoSchemaParams({required this.videoSchema, required this.scale});
}
