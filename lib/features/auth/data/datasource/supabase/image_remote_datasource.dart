import 'dart:io';

import 'package:graduation_thesis_front_end/core/common/params/image_params.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class ImageRemoteDataSource {
  Future<List<ImageParams>> uploadImageList({
    required List<File> imageParams,
    required String userId,
  });
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final SupabaseClient supabaseClient;

  ImageRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ImageParams>> uploadImageList({
    required List<File> imageParams,
    required String userId,
  }) async {
    try {
      const bucket = "gallery_image";
      final uuid = Uuid();

      final uploadFutures = imageParams.map((file) async {
        final imageName = "$userId/${uuid.v1()}";

        await supabaseClient.storage.from(bucket).upload(imageName, file);

        return ImageParams(imageBucketId: bucket, imageName: imageName);
      }).toList();

      final results = await Future.wait(uploadFutures);
      return results;
    } catch (e) {
      print(e);
      throw ServerException("Failed to upload images.");
    }
  }
}
