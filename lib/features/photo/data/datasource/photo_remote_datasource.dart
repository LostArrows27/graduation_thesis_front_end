import 'package:graduation_thesis_front_end/core/common/model/image_model.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PhotoRemoteDataSource {
  Future<List<ImageModel>> getAllUserImage({
    required String userId,
  });

  Future<String> editImageCaption(
      {required String caption, required String imageId});

  Future<void> deleteImage(
      {required String imageBucketId, required String imageName});

  Future<void> favoriteImage(
      {required String imageId, required bool isFavorite});
}

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final SupabaseClient supabaseClient;

  PhotoRemoteDataSourceImpl({required this.supabaseClient});

  String get getUserId => supabaseClient.auth.currentUser!.id;

  @override
  Future<List<ImageModel>> getAllUserImage({required String userId}) async {
    try {
      final res = await supabaseClient
          .from('image')
          .select(
              'id, created_at, updated_at, image_bucket_id, image_name, labels, caption, is_favorite, longitude, latitude, location_meta_data')
          .eq('uploader_id', userId)
          .order('created_at', ascending: false);

      var test = res.map((e) {
        String url = supabaseClient.storage
            .from(e['image_bucket_id'])
            .getPublicUrl(e['image_name']);
        return ImageModel.fromJson(e).copyWith(imageUrl: url);
      }).toList();

      return test;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to get user images.");
    }
  }

  @override
  Future<String> editImageCaption(
      {required String caption, required String imageId}) async {
    try {
      await supabaseClient
          .from('image')
          .update({'caption': caption})
          .eq('uploader_id', getUserId)
          .eq('id', imageId);

      return imageId;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to get user images.");
    }
  }

  @override
  Future<void> deleteImage(
      {required String imageBucketId, required String imageName}) async {
    try {
      await supabaseClient.storage.from(imageBucketId).remove([imageName]);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to delete images.");
    }
  }

  @override
  Future<void> favoriteImage(
      {required String imageId, required bool isFavorite}) async {
    try {
      await supabaseClient
          .from('image')
          .update({'is_favorite': isFavorite})
          .eq('uploader_id', getUserId)
          .eq('id', imageId);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to favorite image.");
    }
  }
}
