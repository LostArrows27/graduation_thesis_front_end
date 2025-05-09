import 'dart:convert';

import 'package:graduation_thesis_front_end/core/common/params/image_params.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/core/common/model/image_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. image upload to supabase -> return imageBucketId + imageName
// 2. imageBucketId + imageName + userid -> get image labels

abstract interface class ImageLabelRemoteDataSource {
  Future<List<ImageModel>> getLabelImages({
    required List<ImageParams> imageParams,
  });
}

class ImageLabelRemoteDataSourceImpl implements ImageLabelRemoteDataSource {
  final String endPointUrl;
  final SupabaseClient supabaseClient;

  ImageLabelRemoteDataSourceImpl(
      {this.endPointUrl = 'http://10.0.2.2:8080/api/classify-images',
      required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  Future<List<ImageModel>> getLabelImages({
    required List<ImageParams> imageParams,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "user_id": userId,
        "data": imageParams.map((param) {
          return {
            "image_bucket_id": param.imageBucketId,
            "image_name": param.imageName,
            "image_id": param.imageId,
          };
        }).toList(),
      };

      final http.Response response = await http.post(
        Uri.parse(endPointUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);

        if (responseJson["status"] != 'success') {
          throw ServerException("Server error: ${responseJson['message']}");
        }

        if (responseJson["status"] == "success") {
          final List<dynamic> data = responseJson["data"];
          final imageList = data
              .map((imageJson) =>
                  ImageModel.fromJson(imageJson as Map<String, dynamic>))
              .toList();

          final imageListWithUrl = imageList.map((image) {
            final url = supabaseClient.storage
                .from(image.imageBucketId)
                .getPublicUrl(image.imageName);
            return image.copyWith(imageUrl: url);
          }).toList();

          return imageListWithUrl;
        } else {
          throw ServerException("Server error: ${responseJson['message']}");
        }
      } else {
        print(response.body);
        throw ServerException(
            "Failed to fetch label images. Status code: ${response.statusCode}");
      }
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to fetch label images.");
    }
  }
}
