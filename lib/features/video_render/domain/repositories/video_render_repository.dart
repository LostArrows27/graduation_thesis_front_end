import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class VideoRenderRepository {
  Future<Either<Failure, VideoSchema>> uploadImageAndGetVideoSchema(
      {required List<SelectedImage> offlineImagesList,
      required List<String> onlineImageIdList,
      required String userId});

  Future<Either<Failure, VideoSchema>> editVideoSchema(
      {required VideoSchema videoSchema, required String scale});

  Future<Either<Failure, VideoRender>> getVideoRenderStatus(
      {required String videoRenderId});

  Future<Either<Failure, List<VideoRender>>> getAllVideoRenderStatus();

  RealtimeChannel onVideoRenderStatusChange(
      {required String videoRenderId, required Function(VideoRender) callback});

  RealtimeChannel listenVideoRenderListChange(
      {required Function(VideoRender) callback});

  void unSubcribeToVideoRenderChannel({
    required String channelName,
  });
  void unSubcribeToRenderListChannel();
}
