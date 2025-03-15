import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/error/failure.dart';

abstract interface class LocationRepository {
  Future<Either<Failure, void>> updateImagesLocation({
    required double longitude,
    required double latitude,
    required Placemark locationMetaData,
    required List<Photo> photos,
  });
}
