import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/model/video_chunk_model.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class VideoRenderDatasource {
  Future<String> createVideoSchema();

  Future<VideoRender> getVideoRenderStatus({required String videoRenderId});
  Future<List<VideoRender>> getAllVideoRenderStatus();

  RealtimeChannel onVideoRenderStatusChange(
      {required String videoRenderId, required Function(VideoRender) callback});

  RealtimeChannel listenVideoRenderListChange(
      {required Function(VideoRender) callback});

  void unSubcribeToVideoRenderChannel({
    required String channelName,
  });

  void unSubcribeToRenderListChannel();

  Future<VideoChunkModel> getVideoChunks({required String videoRenderId});
}

class VideoRenderDatasourceImpl implements VideoRenderDatasource {
  final SupabaseClient supabaseClient;

  VideoRenderDatasourceImpl({required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  Future<String> createVideoSchema() async {
    try {
      final videoSchema = await supabaseClient
          .from('video_render')
          .insert({
            'request_user_id': userId,
          })
          .select()
          .single();

      return videoSchema['id'] as String;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to create video schema');
    }
  }

  @override
  RealtimeChannel onVideoRenderStatusChange(
      {required String videoRenderId,
      required Function(VideoRender) callback}) {
    return supabaseClient
        .channel('video_render_preview:$videoRenderId')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'video_render',
            callback: (payload) async {
              final data = payload.newRecord;
              VideoRender newSchema = VideoRender.fromJson(data);

              callback(newSchema);
            },
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: videoRenderId))
        .subscribe();
  }

  @override
  void unSubcribeToVideoRenderChannel({required String channelName}) {
    supabaseClient.channel(channelName).unsubscribe();
  }

  @override
  Future<VideoRender> getVideoRenderStatus(
      {required String videoRenderId}) async {
    try {
      final videoSchema = await supabaseClient
          .from('video_render')
          .select('id, status, progress, created_at, updated_at')
          .eq('id', videoRenderId)
          .single();

      return VideoRender.fromJson(videoSchema);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to get video schema');
    }
  }

  @override
  Future<List<VideoRender>> getAllVideoRenderStatus() async {
    try {
      final videoSchema = await supabaseClient
          .from('video_render')
          .select(
              'id, status, progress, created_at, updated_at, thumbnail_url, title: schema->introScene->firstScene->title')
          .eq('request_user_id', userId)
          .order('created_at', ascending: false);

      return videoSchema.map((e) => VideoRender.fromJson(e)).toList();
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to get user video render list');
    }
  }

  @override
  RealtimeChannel listenVideoRenderListChange(
      {required Function(VideoRender p1) callback}) {
    return supabaseClient
        .channel('video_render_list:$userId')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'video_render',
            callback: (payload) async {
              final data = payload.newRecord;
              VideoRender newSchema = VideoRender.fromJson(data);

              callback(newSchema);
            },
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'request_user_id',
                value: userId))
        .subscribe();
  }

  @override
  void unSubcribeToRenderListChannel() {
    supabaseClient.channel('video_render_list:$userId').unsubscribe();
  }

  @override
  Future<VideoChunkModel> getVideoChunks(
      {required String videoRenderId}) async {
    try {
      final res = await supabaseClient
          .from('video_chunk')
          .select()
          .eq('video_id', videoRenderId)
          .single();

      return VideoChunkModel.fromJson(res).copyWith(
        url: supabaseClient.storage
            .from(res['chunk_bucket_id'])
            .getPublicUrl(res['chunk_name']),
      );
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to get video chunks');
    }
  }
}
