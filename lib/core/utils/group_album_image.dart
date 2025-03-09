// NOTE: refer group_image.dart
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:intl/intl.dart';

List<Photo> getAllPhotoFromGroupImage(List<AlbumFolder> albumFolder) {
  List<Photo> photos = [];

  for (var folder in albumFolder) {
    photos.addAll(folder.photos);
  }

  return photos;
}

List<AlbumFolder> groupImagePhotoByWeek(List<Photo> monthPhoto) {
  // new photo list -> not refer to old photos
  List<Photo> sortedPhoto = List.from(monthPhoto)
    ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

  Map<String, List<Photo>> datePhotoGroup = {};
  List<AlbumFolder> albumFolder = [];

  for (Photo photo in sortedPhoto) {
    DateTime photoDate = photo.createdAt!;

    String dateTitle = DateFormat('yyyy-MM-dd').format(photoDate);

    if (!datePhotoGroup.containsKey(dateTitle)) {
      datePhotoGroup[dateTitle] = [];
    }
    datePhotoGroup[dateTitle]!.add(photo);
  }

  datePhotoGroup.forEach((key, photos) {
    final DateTime keyDate = DateTime.parse(key);

    final String title = formatDate(keyDate);
    albumFolder.add(AlbumFolder(title: title, photos: photos));
  });

  albumFolder.sort((a, b) {
    final DateTime aDate = DateTime.parse(a.photos.first.createdAt.toString());
    final DateTime bDate = DateTime.parse(b.photos.first.createdAt.toString());

    return bDate.compareTo(aDate);
  });

  return albumFolder;
}
