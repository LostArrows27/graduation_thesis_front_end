part of 'upload_photo_bloc.dart';

@immutable
sealed class UploadPhotoEvent {}

// upload image
final class UploadImagesEvent extends UploadPhotoEvent {
  final List<File> images;

  UploadImagesEvent({required this.images});
}
