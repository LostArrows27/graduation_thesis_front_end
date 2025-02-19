import 'package:graduation_thesis_front_end/core/common/model/image_model.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PhotoRemoteDataSource {
  Future<List<ImageModel>> getAllUserImage({
    required String userId,
  });
}

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final SupabaseClient supabaseClient;

  PhotoRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ImageModel>> getAllUserImage({required String userId}) async {
    try {
      final res = await supabaseClient
          .from('image')
          .select('*')
          .eq('uploader_id', userId)
          .order('created_at', ascending: false);

      var test = res.map((e) {
        String url = supabaseClient.storage
            .from(e['image_bucket_id'])
            .getPublicUrl(e['image_name']);
        return ImageModel.fromJson(e).copyWith(imageUrl: url);
      }).toList();

      return test;
    } catch (e) {
      print(e);
      throw ServerException("Failed to get user images.");
    }
  }
}
