// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class Photo {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uploaderId;
  final String imageBucketId;
  final String imageName;
  final LabelResponse labels;
  final String? imageUrl;
  final String? caption;

  Photo(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.caption,
      required this.uploaderId,
      required this.imageBucketId,
      required this.imageName,
      required this.labels});

  Photo copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? uploaderId,
    String? imageBucketId,
    String? imageName,
    LabelResponse? labels,
    String? imageUrl,
    String? caption,
  }) {
    return Photo(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      uploaderId: uploaderId ?? this.uploaderId,
      imageBucketId: imageBucketId ?? this.imageBucketId,
      imageName: imageName ?? this.imageName,
      labels: labels ?? this.labels,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
    );
  }
}
