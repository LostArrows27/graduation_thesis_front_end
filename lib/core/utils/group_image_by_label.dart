import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/utils/string_captialize.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';

List<AlbumFolder> groupImageByLabel(List<Photo> photos, SmartTagsType type) {
  List<AlbumFolder> albumFolder = [];

  Map<String, List<Photo>> labelGroup = {};

  switch (type) {
    case SmartTagsType.location:
      for (var photo in photos) {
        if (photo.labels.labels.locationLabels.isNotEmpty) {
          final label = photo.labels.labels.locationLabels[0].label;

          if (!labelGroup.containsKey(label)) {
            labelGroup[label] = [];
          }

          labelGroup[label]!.add(photo);
        }
      }
      break;
    case SmartTagsType.event:
      for (var photo in photos) {
        if (photo.labels.labels.eventLabels.isNotEmpty) {
          final label = photo.labels.labels.eventLabels[0].label;

          if (!labelGroup.containsKey(label)) {
            labelGroup[label] = [];
          }

          labelGroup[label]!.add(photo);
        }
      }
      break;
    case SmartTagsType.activity:
      for (var photo in photos) {
        if (photo.labels.labels.actionLabels.isNotEmpty) {
          final label = photo.labels.labels.actionLabels[0].label;

          if (!labelGroup.containsKey(label)) {
            labelGroup[label] = [];
          }

          labelGroup[label]!.add(photo);
        }
      }
      break;
    default:
      for (var photo in photos) {
        if (photo.labels.labels.locationLabels.isNotEmpty) {
          final label = photo.labels.labels.locationLabels[0].label;

          if (!labelGroup.containsKey(label)) {
            labelGroup[label] = [];
          }

          labelGroup[label]!.add(photo);
        }
      }
  }

  labelGroup.forEach((key, value) {
    albumFolder.add(AlbumFolder(title: captializeString(key), photos: value));
  });

  return albumFolder;
}
