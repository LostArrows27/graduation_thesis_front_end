import 'dart:convert';

import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/model/video_schema_model.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

abstract interface class VideoRenderRemoteDatasource {
  Future<VideoSchema> getVideoSchema(
      {required List<String> imageIdList, required String renderQueueId});

  Future<VideoSchema> editVideoSchema(
      {required VideoSchema videoSchema, required String scale});
}

class VideoRenderRemoteDatasourceImpl implements VideoRenderRemoteDatasource {
  final String endPointUrl;
  final SupabaseClient supabaseClient;

  VideoRenderRemoteDatasourceImpl(
      {required this.supabaseClient,
      this.endPointUrl = 'http://10.0.2.2:5000/api'});

  @override
  Future<VideoSchema> getVideoSchema(
      {required List<String> imageIdList,
      required String renderQueueId}) async {
    /*
        { 
          accessToken: "eq433",
          imageIdList: ["1", "2", "3"],
          renderQueueId: "12345"
        }
    */
    try {
      final Map<String, dynamic> requestBody = {
        "imageIdList": imageIdList,
        "renderQueueId": renderQueueId,
        'accessToken': supabaseClient.auth.currentSession?.accessToken,
      };

      final http.Response response = await http.post(
        Uri.parse('$endPointUrl/schema/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);

        return VideoSchemaModel.fromJson(responseJson['data']);
      } else {
        print(jsonDecode(response.body)['error']);
        throw ServerException('Failed to get video schema');
      }
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to get video schema');
    }
  }

  @override
  Future<VideoSchema> editVideoSchema(
      {required VideoSchema videoSchema, required String scale}) async {
    try {
      final Map<String, dynamic> requestBody = {
        "renderQueueId": videoSchema.videoRenderId,
        'accessToken': supabaseClient.auth.currentSession?.accessToken,
        'option': {
          'title': videoSchema.videoTitle,
          'titleStyle': videoSchema.titleStyle,
          'bgVideoTheme': videoSchema.bgVideoTheme,
          'bgMusic': videoSchema.bgMusic,
          'maxDuration': videoSchema.maxDuration,
        }
      };

      final http.Response response = await http.post(
        Uri.parse('$endPointUrl/schema/edit'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);

        final Map<String, dynamic> requestBody = {
          'accessToken': supabaseClient.auth.currentSession?.accessToken,
          "renderQueueId": videoSchema.videoRenderId,
          "scale": [1, 1.5].contains(int.parse(scale)) ? int.parse(scale) : 1,
        };

        final http.Response videoRenderRes = await http.post(
          Uri.parse('$endPointUrl/video/create-video'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        if (videoRenderRes.statusCode != 200) {
          print(jsonDecode(videoRenderRes.body)['error']);
          throw ServerException('Failed to edit video schema');
        }

        return VideoSchemaModel.fromJson(responseJson['data']);
      } else {
        print(jsonDecode(response.body)['error']);
        throw ServerException('Failed to edit video schema');
      }
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to edit video schema');
    }
  }
}
