part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class PhotoFetchAllEvent extends PhotoEvent {
  final String userId;

  PhotoFetchAllEvent({required this.userId});
}

final class PhotoClearEvent extends PhotoEvent {}

// add uploaded image
final class PhotoAddImagesEvent extends PhotoEvent {
  final List<Photo> photos;

  PhotoAddImagesEvent({required this.photos});
}
