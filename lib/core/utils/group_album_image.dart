// NOTE: refer group_image.dart
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/year_album_folder.dart';
import 'package:intl/intl.dart';

List<Photo> getAllPhotoFromFaceGroup(List<Face> faceList) {
  List<Photo> photos = [];

  for (var face in faceList) {
    photos.add(Photo(
        id: face.imageId,
        imageUrl: face.imageUrl,
        uploaderId: '',
        createdAt: face.imageCreatedAt,
        imageBucketId: face.imageBucketId,
        imageName: face.imageName,
        labels: face.imageLabel));
  }

  return photos;
}

List<Photo> getAllPhotoFromGroupImage(List<AlbumFolder> albumFolder) {
  List<Photo> photos = [];

  for (var folder in albumFolder) {
    photos.addAll(folder.photos);
  }

  return photos;
}

List<Photo> getAllPhotoFromYearAlbum(List<YearAlbumFolder> yearAlbumFolder) {
  List<Photo> photos = [];

  for (var yearFolder in yearAlbumFolder) {
    for (var photoFolder in yearFolder.folderList) {
      photos.addAll(photoFolder.photos);
    }
  }

  return photos;
}

List<AlbumFolder> groupImagePhotoByDate(List<Photo> monthPhoto) {
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

// class YearAlbumFolder {
//   final String bigTitle;
//   final List<AlbumFolder> folderList;

//   YearAlbumFolder({required this.bigTitle, required this.folderList});
// }

List<YearAlbumFolder> groupImageByMonthAndWeek(List<Photo> yearPhoto) {
  // Sort all photos by date (newest first)
  List<Photo> sortedPhotos = List.from(yearPhoto)
    ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

  // Group photos by month
  Map<String, List<Photo>> monthPhotoGroups = {};

  for (Photo photo in sortedPhotos) {
    DateTime photoDate = photo.createdAt!;
    String monthKey = DateFormat('yyyy-MM').format(photoDate);

    if (!monthPhotoGroups.containsKey(monthKey)) {
      monthPhotoGroups[monthKey] = [];
    }
    monthPhotoGroups[monthKey]!.add(photo);
  }

  // Create YearAlbumFolder list
  List<YearAlbumFolder> yearAlbumFolders = [];

  // Process each month group
  monthPhotoGroups.forEach((monthKey, monthPhotos) {
    final DateTime monthDate = DateTime.parse('$monthKey-01');
    final String monthTitle = DateFormat('MMMM').format(monthDate);

    // Group photos in this month by week
    Map<int, List<Photo>> weekPhotoGroups = {};

    for (Photo photo in monthPhotos) {
      DateTime photoDate = photo.createdAt!;
      // Get week of month (1-based)
      int weekNumber = ((photoDate.day - 1) ~/ 7) + 1;

      if (!weekPhotoGroups.containsKey(weekNumber)) {
        weekPhotoGroups[weekNumber] = [];
      }
      weekPhotoGroups[weekNumber]!.add(photo);
    }

    // Create AlbumFolder for each week
    List<AlbumFolder> weekAlbumFolders = [];

    weekPhotoGroups.forEach((weekNum, weekPhotos) {
      // Sort photos in this week
      weekPhotos.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Find start and end date of the week
      DateTime weekStart = weekPhotos.last.createdAt!;
      DateTime weekEnd = weekPhotos.first.createdAt!;

      // Format the title as "Jan 02 - Jan 08"
      String weekTitle =
          '${DateFormat('MMM dd').format(weekStart)} - ${DateFormat('MMM dd').format(weekEnd)}';

      if (DateFormat('MMM dd').format(weekStart) ==
          DateFormat('MMM dd').format(weekEnd)) {
        weekTitle = DateFormat('MMM dd').format(weekStart);
      }

      weekAlbumFolders.add(AlbumFolder(title: weekTitle, photos: weekPhotos));
    });

    // Sort week folders by date (newest first)
    weekAlbumFolders.sort((a, b) {
      final DateTime aDate = a.photos.first.createdAt!;
      final DateTime bDate = b.photos.first.createdAt!;
      return bDate.compareTo(aDate);
    });

    // Create YearAlbumFolder for this month
    yearAlbumFolders.add(YearAlbumFolder(
      bigTitle: monthTitle,
      folderList: weekAlbumFolders,
    ));
  });

  // Sort months by date (newest first)
  yearAlbumFolders.sort((a, b) {
    final DateTime aDate = a.folderList.first.photos.first.createdAt!;
    final DateTime bDate = b.folderList.first.photos.first.createdAt!;
    return bDate.compareTo(aDate);
  });

  return yearAlbumFolders;
}
