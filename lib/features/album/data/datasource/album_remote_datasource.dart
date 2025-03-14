import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/album/data/model/album_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AlbumRemoteDatasource {
  Future<AlbumModel> createAlbum({
    required String name,
    required List<String> imageId,
  });

  Future<List<AlbumModel>> getAllAlbums();

  Future<void> deleteAlbum(String albumId);

  Future<void> changeAlbumName(String albumId, String newName);
}

class AlbumRemoteDatasourceImpl implements AlbumRemoteDatasource {
  final SupabaseClient supabaseClient;

  AlbumRemoteDatasourceImpl({required this.supabaseClient});

  String get userId => supabaseClient.auth.currentUser!.id;

  @override
  Future<AlbumModel> createAlbum({
    required String name,
    required List<String> imageId,
  }) async {
    try {
      final res = await supabaseClient
          .from('album')
          .insert({'name': name, 'owner_id': userId})
          .select('id, created_at, updated_at')
          .single();

      final albumId = res['id'] as String;

      final albumImageMap =
          imageId.map((id) => {'album_id': albumId, 'image_id': id}).toList();

      await supabaseClient.from('album_image').insert(albumImageMap);

      return AlbumModel(
          id: albumId,
          imageIdList: imageId,
          ownerId: userId,
          createdAt: DateTime.parse(res['created_at']),
          updatedAt: DateTime.parse(res['updated_at']),
          imageList: [],
          name: name);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to create user album.");
    }
  }

  @override
  Future<List<AlbumModel>> getAllAlbums() async {
    try {
      final res = await supabaseClient
          .from('album')
          .select('id, name, created_at, updated_at, album_image(image_id)')
          .eq('owner_id', userId);

      final albumList = res.map((e) {
        return AlbumModel(
          id: e['id'] as String,
          name: e['name'] as String,
          ownerId: userId,
          createdAt: DateTime.parse(e['created_at']),
          updatedAt: DateTime.parse(e['updated_at']),
          imageIdList: (e['album_image'] as List)
              .map((e) => e['image_id'] as String)
              .toList(),
          imageList: [],
        );
      }).toList();

      return albumList;
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to get user albums.");
    }
  }

  @override
  Future<void> deleteAlbum(String albumId) async {
    try {
      await supabaseClient.from('album').delete().eq('id', albumId);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to delete this albums.");
    }
  }

  @override
  Future<void> changeAlbumName(String albumId, String newName) async {
    try {
      await supabaseClient
          .from('album')
          .update({'name': newName}).eq('id', albumId);
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException("Failed to change album name.");
    }
  }
}
