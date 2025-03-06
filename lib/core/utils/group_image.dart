import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:intl/intl.dart';

List<Map<String, dynamic>> groupImageByDate(List<Photo> images) {
  Map<String, List<Photo>> groupedImages = {};

  for (var image in images) {
    String dateStr = DateFormat('yyyy-MM-dd').format(image.createdAt!);
    if (!groupedImages.containsKey(dateStr)) {
      groupedImages[dateStr] = [];
    }
    groupedImages[dateStr]!.add(image);
  }

  List<Map<String, dynamic>> result = groupedImages.entries.map((entry) {
    var dates = entry.key.split('-');

    return {
      'date': DateTime(
          int.parse(dates[0]), int.parse(dates[1]), int.parse(dates[2])),
      'images': entry.value,
    };
  }).toList();

  return result;
}

List<Map<String, dynamic>> groupImageByMonth(List<Photo> data) {
  List<Map<String, dynamic>> groupedByMonth = [];

  for (var photo in data) {
    DateTime date = photo.createdAt!;
    String month = DateFormat.MMM().format(date);
    int year = date.year;

    var yearGroup = groupedByMonth.firstWhere(
      (group) => group['year'] == year,
      orElse: () => {'year': year, 'group': []},
    );

    if (!groupedByMonth.contains(yearGroup)) {
      groupedByMonth.add(yearGroup);
    }

    if (yearGroup['group'] != null) {
      var monthGroup = yearGroup['group'].firstWhere(
        (group) => group['month'] == month,
        orElse: () => null,
      );

      if (monthGroup == null) {
        yearGroup['group'].add({
          'month': month,
          'images': [photo]
        });
      } else {
        monthGroup['images'].add(photo);
      }
    }
  }

  return groupedByMonth;
}

List<Map<String, dynamic>> groupImageByYear(List<Photo> data) {
  Map<String, List<Photo>> groupedImages = {};

  for (var image in data) {
    String dateStr = DateFormat('yyyy').format(image.createdAt!);
    if (!groupedImages.containsKey(dateStr)) {
      groupedImages[dateStr] = [];
    }
    groupedImages[dateStr]!.add(image);
  }

  List<Map<String, dynamic>> result = groupedImages.entries.map((entry) {
    return {
      'year': entry.key,
      'images': entry.value,
    };
  }).toList();

  return result;
}

List<Map<String, dynamic>> groupImageFaceByDate(List<Face> faces) {
  Map<String, List<Face>> groupedFace = {};

  final tempFaces = List<Face>.from(faces);

  tempFaces.sort((a, b) => b.imageCreatedAt.compareTo(a.imageCreatedAt));

  for (var face in tempFaces) {
    String dateStr = DateFormat('yyyy-MM-dd').format(face.imageCreatedAt);
    if (!groupedFace.containsKey(dateStr)) {
      groupedFace[dateStr] = [];
    }
    groupedFace[dateStr]!.add(face);
  }

  List<Map<String, dynamic>> result = groupedFace.entries.map((entry) {
    var dates = entry.key.split('-');

    return {
      'date': DateTime(
          int.parse(dates[0]), int.parse(dates[1]), int.parse(dates[2])),
      'faces': entry.value,
    };
  }).toList();

  return result;
}
