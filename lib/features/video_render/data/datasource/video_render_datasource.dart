import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class VideoRenderDatasource {
  Future<String> createVideoSchema();
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
}
