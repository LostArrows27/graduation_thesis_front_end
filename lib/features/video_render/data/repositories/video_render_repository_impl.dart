import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_thesis_front_end/core/common/params/image_params.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/python/image_label_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/auth/data/datasource/supabase/image_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/datasource/video_render_datasource.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/datasource/video_render_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/repositories/video_render_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoRenderRepositoryImpl implements VideoRenderRepository {
  final ImageRemoteDataSource imageRemoteDataSource;
  final ImageLabelRemoteDataSource imageLabelRemoteDataSource;
  final VideoRenderDatasource videoRenderSupabaseDatasource;
  final VideoRenderRemoteDatasource videoRenderNodeJsDatasource;

  const VideoRenderRepositoryImpl(
      {required this.imageRemoteDataSource,
      required this.imageLabelRemoteDataSource,
      required this.videoRenderSupabaseDatasource,
      required this.videoRenderNodeJsDatasource});

  @override
  Future<Either<Failure, VideoSchema>> uploadImageAndGetVideoSchema(
      {required List<SelectedImage> offlineImagesList,
      required List<String> onlineImageIdList,
      required String userId}) async {
    try {
      // 1. upload offline image
      final offlineImageFiles = offlineImagesList
          .where((element) => element.source == Source.offline)
          .map((e) => File(e.filePath))
          .toList();

      final offlineImageIdLists =
          await imageRemoteDataSource.uploadImageListAndGetId(
              imageParams: offlineImageFiles, userId: userId);

      // 2. upload to python server to label
      await imageLabelRemoteDataSource.getLabelImages(
          imageParams: offlineImageIdLists
              .map((e) => ImageParams(
                  imageBucketId: e.imageBucketId, imageName: e.imageName))
              .toList(),
          userId: userId);

      // 3. mapping offline image + online image -> List<String> imageIdLists
      final imageIdLists =
          offlineImageIdLists.map((e) => e.id).toList() + onlineImageIdList;

      // 4. get renderVideoId from imageIdLists
      final renderVideoId =
          await videoRenderSupabaseDatasource.createVideoSchema();

      // 5. get videoSchema from renderVideoId
      final videoSchema = await videoRenderNodeJsDatasource.getVideoSchema(
          imageIdList: imageIdLists, renderQueueId: renderVideoId);

      return right(videoSchema);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, VideoSchema>> editVideoSchema(
      {required VideoSchema videoSchema, required String scale}) async {
    try {
      final editedVideoSchema = await videoRenderNodeJsDatasource
          .editVideoSchema(videoSchema: videoSchema, scale: scale);
      return right(editedVideoSchema);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  RealtimeChannel onVideoRenderStatusChange(
      {required String videoRenderId,
      required Function(VideoRender) callback}) {
    return videoRenderSupabaseDatasource.onVideoRenderStatusChange(
        videoRenderId: videoRenderId, callback: callback);
  }

  @override
  void unSubcribeToMessagesChannel({required String channelName}) {
    videoRenderSupabaseDatasource.unSubcribeToVideoRenderChannel(
        channelName: channelName);
  }

  @override
  Future<Either<Failure, VideoRender>> getVideoSchema(
      {required String videoRenderId}) async {
    try {
      final videoSchema = await videoRenderSupabaseDatasource.getVideoRenderStatus(
          videoRenderId: videoRenderId);
      return right(videoSchema);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
