import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/location/domain/repositories/location_repository.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';

part 'update_location_state.dart';

class UpdateLocationCubit extends Cubit<UpdateLocationState> {
  final LocationRepository _locationRepository;
  final PhotoBloc _photoBloc;

  UpdateLocationCubit(
      {required LocationRepository locationRepository,
      required PhotoBloc photoBloc})
      : _locationRepository = locationRepository,
        _photoBloc = photoBloc,
        super(UpdateLocationInitial());

  Future<void> updateImagesLocation({
    required double longitude,
    required double latitude,
    required Placemark locationMetaData,
    required List<Photo> photos,
  }) async {
    emit(UpdateLocationLoading());

    final result = await _locationRepository.updateImagesLocation(
      longitude: longitude,
      latitude: latitude,
      locationMetaData: locationMetaData,
      photos: photos,
    );
    result.fold(
      (failure) => emit(UpdateLocationFailure(message: failure.message)),
      (success) {
        _photoBloc.add(PhotoLocationUpdate(
            longitude: longitude,
            latitude: latitude,
            locationMetaData: locationMetaData,
            photos: photos));

        emit(UpdateLocationSuccess(
            latitude: latitude,
            longitude: longitude,
            placemark: locationMetaData));
      },
    );
  }
}
