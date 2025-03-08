part of 'upload_photo_bloc.dart';

@immutable
sealed class UploadPhotoState {}

final class UploadPhotoInitial extends UploadPhotoState {}


final class UploadImagesLoading extends UploadPhotoState {}

final class UploadImageSuccess extends UploadPhotoState {
  final List<Photo> photos;

  UploadImageSuccess({required this.photos});
}

final class UploadImagesFailure extends UploadPhotoState {
  final String message;

  UploadImagesFailure({required this.message});
}
