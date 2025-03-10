// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class Face {
  final int id;
  final List<int> coordinate;
  final String imageUrl;
  final DateTime imageCreatedAt;
  final String imageId;
  final String imageName;
  final String imageBucketId;
  final LabelResponse imageLabel;

  Face(
      {required this.id,
      required this.coordinate,
      required this.imageUrl,
      required this.imageId,
      required this.imageName,
      required this.imageBucketId,
      required this.imageLabel,
      required this.imageCreatedAt});
}
