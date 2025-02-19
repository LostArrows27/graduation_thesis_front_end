part of 'photo_bloc.dart';

@immutable
sealed class PhotoState {}

final class PhotoInitial extends PhotoState {}

final class PhotoFetchLoading extends PhotoState {}

final class PhotoFetchSuccess extends PhotoState {
  final List<Photo> photos;
  final List<Map<String, dynamic>> groupedByDate;
  final List<Map<String, dynamic>> groupedByYear;
  final List<Map<String, dynamic>> groupedByMonth;

  PhotoFetchSuccess(
      {required this.photos,
      required this.groupedByDate,
      required this.groupedByYear,
      required this.groupedByMonth});
}

final class PhotoFetchFailure extends PhotoState {
  final String message;

  PhotoFetchFailure({required this.message});
}
