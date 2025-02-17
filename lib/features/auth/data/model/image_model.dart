import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class ImageModel extends Image {
  ImageModel(
      {required super.id,
      super.createdAt,
      super.updatedAt,
      required super.uploaderId,
      required super.imageBucketId,
      required super.imageName,
      required super.labels});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
      uploaderId: json['uploader_id'] as String?,
      imageBucketId: json['image_bucket_id'] as String,
      imageName: json['image_name'] as String,
      labels: LabelResponse.fromJson(json['labels'] as Map<String, dynamic>),
    );
  }
}
