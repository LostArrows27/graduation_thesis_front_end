import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/service/location_services.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/location_group.dart';

List<LocationGroup> groupImageByLocation(List<Photo> photos) {
  List<LocationGroup> groups = [];

  final locationPhotos = photos.where((photo) =>
      photo.longitude != null &&
      photo.latitude != null &&
      photo.locationMetaData != null);

  Map<String, List<Photo>> locationGroup = {};

  for (var photo in locationPhotos) {
    var commonAddress =
        LocationService.getCommonAddress(photo.locationMetaData!);

    if (locationGroup[commonAddress] == null) {
      locationGroup[commonAddress] = [];
    }

    locationGroup[commonAddress]!.add(photo);
  }

  locationGroup.forEach((groupName, photo) {
    groups.add(LocationGroup(name: groupName, photos: photo));
  });

  return groups;
}
