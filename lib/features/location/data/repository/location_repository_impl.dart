import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';
import 'package:graduation_thesis_front_end/core/error/server_exception.dart';
import 'package:graduation_thesis_front_end/features/location/data/datasource/location_remote_datasource.dart';
import 'package:graduation_thesis_front_end/features/location/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDatasource locationRemoteDatasource;

  const LocationRepositoryImpl({
    required this.locationRemoteDatasource,
  });

  @override
  Future<Either<Failure, void>> updateImagesLocation({
    required double longitude,
    required double latitude,
    required Placemark locationMetaData,
    required List<Photo> photos,
  }) async {
    try {
      await locationRemoteDatasource.updateImagesLocation(
        longitude: longitude,
        latitude: latitude,
        locationMetaData: locationMetaData,
        photos: photos,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
