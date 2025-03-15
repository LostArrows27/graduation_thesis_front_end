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

final class PhotoFavoriteEvent extends PhotoEvent {
  final String imageId;
  final bool isFavorite;

  PhotoFavoriteEvent({required this.imageId, required this.isFavorite});
}

// update image location
final class PhotoLocationUpdate extends PhotoEvent {
  final double longitude;
  final double latitude;
  final Placemark locationMetaData;
  final List<Photo> photos;

  PhotoLocationUpdate({
    required this.longitude,
    required this.latitude,
    required this.locationMetaData,
    required this.photos,
  });
}
