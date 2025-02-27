import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class VideoRenderDatasource {
  Future<String> createVideoSchema();

  Future<VideoRender> getVideoRenderStatus({required String videoRenderId});

  RealtimeChannel onVideoRenderStatusChange(
      {required String videoRenderId, required Function(VideoRender) callback});

  void unSubcribeToVideoRenderChannel({
    required String channelName,
  });
}

class VideoRenderDatasourceImpl implements VideoRenderDatasource {
  final SupabaseClient supabaseClient;

  VideoRenderDatasourceImpl({required this.supabaseClient});

  @override
  Future<String> createVideoSchema() async {
    try {
      final videoSchema = await supabaseClient
          .from('video_render')
          .insert({
            'request_user_id': supabaseClient.auth.currentUser!.id,
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
}
