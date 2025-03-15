part of 'update_location_cubit.dart';

@immutable
sealed class UpdateLocationState {}

final class UpdateLocationInitial extends UpdateLocationState {}

final class UpdateLocationLoading extends UpdateLocationState {}

final class UpdateLocationSuccess extends UpdateLocationState {
  final double latitude;
  final double longitude;
  final Placemark placemark;

  UpdateLocationSuccess(
      {required this.latitude,
      required this.longitude,
      required this.placemark});
}

final class UpdateLocationFailure extends UpdateLocationState {
  final String message;

  UpdateLocationFailure({required this.message});
}
