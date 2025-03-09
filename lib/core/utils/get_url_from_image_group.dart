import 'package:graduation_thesis_front_end/core/common/entities/image.dart';

List<String> getUrlFromImageGroup(List<Map<String, dynamic>> groupedData) {
  List<String> imageUrls = [];

  for (var dateGroup in groupedData) {
    List<Photo> photos = dateGroup['images'] as List<Photo>;

    for (var photo in photos) {
      if (photo.imageUrl != null) {
        imageUrls.add(photo.imageUrl!);
      }
    }
  }

  return imageUrls;
}

List<Photo> getPhotoFromImageGroup(List<Map<String, dynamic>> groupedData) {
  List<Photo> photos = [];

  for (var dateGroup in groupedData) {
    List<Photo> imageList = dateGroup['images'] as List<Photo>;

    for (var photo in imageList) {
      photos.add(photo);
    }
  }

  return photos;
}
