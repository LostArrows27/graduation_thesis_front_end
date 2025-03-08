import 'dart:io';

import 'package:graduation_thesis_front_end/core/common/params/image_params.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/image_id_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class ImageRemoteDataSource {
  Future<List<ImageParams>> uploadImageList({
    required List<File> imageParams,
  });

  Future<List<ImageIdParams>> uploadImageListAndGetId({
    required List<File> imageParams,
    required String userId,
  });
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final SupabaseClient supabaseClient;

  ImageRemoteDataSourceImpl({required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  Future<List<ImageParams>> uploadImageList({
    required List<File> imageParams,
  }) async {
    try {
      const bucket = "gallery_image";
      final uuid = Uuid();

      final uploadFutures = imageParams.map((file) async {
        final imageName = "$userId/${uuid.v1()}";

        await supabaseClient.storage.from(bucket).upload(imageName, file);

        final res = await supabaseClient
            .from('image')
            .insert({
              'uploader_id': userId,
              'image_name': imageName,
              'image_bucket_id': bucket,
              // with no labels -> for DB task python listen
            })
            .select('id')
            .single();

        return ImageParams(
            imageBucketId: bucket,
            imageName: imageName,
            imageId: res['id'] as String);
      }).toList();

      final results = await Future.wait(uploadFutures);
      return results;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to upload images.");
    }
  }

  @override
  Future<List<ImageIdParams>> uploadImageListAndGetId(
      {required List<File> imageParams, required String userId}) async {
    try {
      const bucket = "gallery_image";
      final uuid = Uuid();

      final uploadFutures = imageParams.map((file) async {
        final imageName = "$userId/${uuid.v1()}";

        await supabaseClient.storage.from(bucket).upload(imageName, file);

        final response = await supabaseClient
            .from('image')
            .insert({
              'uploader_id': userId,
              'image_name': imageName,
              'image_bucket_id': bucket,
              'labels': {
                "location_labels": [],
                "action_labels": [],
                "event_labels": []
              }
              // with no labels -> for DB task python listen
            })
            .select()
            .single();

        return ImageIdParams(
            id: response['id'] as String,
            imageBucketId: bucket,
            imageName: imageName);
      }).toList();

      final results = await Future.wait(uploadFutures);
      return results;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to upload images.");
    }
  }
}
