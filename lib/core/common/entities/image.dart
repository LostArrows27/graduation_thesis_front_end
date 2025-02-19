import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class Photo {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uploaderId;
  final String? albumId;
  final String imageBucketId;
  final String imageName;
  final LabelResponse labels;
  final String? imageUrl;

  Photo(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      this.albumId,
      this.imageUrl,
      required this.uploaderId,
      required this.imageBucketId,
      required this.imageName,
      required this.labels});
}
