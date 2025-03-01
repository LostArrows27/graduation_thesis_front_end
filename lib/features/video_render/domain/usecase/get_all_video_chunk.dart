import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_chunk.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';

class GetAllVideoChunk implements UseCase<VideoChunk, GetAllVideoChunkParams> {
  final VideoRenderRepository videoRenderRepository;

  const GetAllVideoChunk({required this.videoRenderRepository});

  @override
  Future<Either<Failure, VideoChunk>> call(
      GetAllVideoChunkParams params) async {
    return await videoRenderRepository.getVideoChunks(
        videoRenderId: params.videoRenderId);
  }
}

class GetAllVideoChunkParams {
  final String videoRenderId;

  GetAllVideoChunkParams({required this.videoRenderId});
}
