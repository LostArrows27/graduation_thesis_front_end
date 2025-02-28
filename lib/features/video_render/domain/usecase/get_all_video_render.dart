import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/usecase/usecase.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';

class GetAllVideoRender implements UseCase<List<VideoRender>, NoParams> {
  final VideoRenderRepository videoRenderRepository;

  const GetAllVideoRender({required this.videoRenderRepository});

  @override
  Future<Either<Failure, List<VideoRender>>> call(NoParams params) async {
    return await videoRenderRepository.getAllVideoRenderStatus();
  }
}
