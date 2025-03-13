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

// edit image caption
final class PhotoEditCaptionEvent extends PhotoEvent {
  final String caption;
  final String imageId;

  PhotoEditCaptionEvent({
    required this.caption,
    required this.imageId,
  });
}

// delete image
final class PhotoDeleteEvent extends PhotoEvent {
  final String imageBucketId;
  final String imageName;

  PhotoDeleteEvent({required this.imageBucketId, required this.imageName});
}
