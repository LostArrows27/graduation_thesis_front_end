import 'dart:convert';

import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/video_render/data/model/video_schema_model.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

abstract interface class VideoRenderRemoteDatasource {
  Future<VideoSchema> getVideoSchema(
      {required List<String> imageIdList, required String renderQueueId});
}

class VideoRenderRemoteDatasourceImpl implements VideoRenderRemoteDatasource {
  final String endPointUrl;
  final SupabaseClient supabaseClient;

  VideoRenderRemoteDatasourceImpl(
      {required this.supabaseClient,
      this.endPointUrl = 'http://10.0.2.2:5000/api/schema'});

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
        Uri.parse('$endPointUrl/create'),
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
}
