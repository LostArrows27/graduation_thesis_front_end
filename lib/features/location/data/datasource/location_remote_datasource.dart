import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class LocationRemoteDatasource {
  Future<void> updateImagesLocation({
    required double longitude,
    required double latitude,
    required Placemark locationMetaData,
    required List<Photo> photos,
  });
}

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final SupabaseClient supabaseClient;

  LocationRemoteDatasourceImpl({required this.supabaseClient});

  String get getUserId => supabaseClient.auth.currentUser!.id;

  @override
  Future<void> updateImagesLocation(
      {required double longitude,
      required double latitude,
      required Placemark locationMetaData,
      required List<Photo> photos}) async {
    try {
      await supabaseClient.from('image').update({
        'longitude': longitude,
        'latitude': latitude,
        'location_meta_data': locationMetaData.toJson(),
      }).inFilter('id', photos.map((e) => e.id).toList());
    } catch (e, c) {
      print(e);
      print(c);
      throw ServerException('Failed to update images location');
    }
  }
}
