import 'package:graduation_thesis_front_end/core/common/entities/label.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';

class FaceModel extends Face {
  FaceModel(
      {required super.id,
      required super.coordinate,
      required super.imageUrl,
      required super.imageCreatedAt,
      required super.imageId,
      required super.imageName,
      required super.imageBucketId,
      required super.imageLabel});

  factory FaceModel.fromJson(
      Map<String, dynamic> map, String Function(String, String) getImageUrl) {
    return FaceModel(
        id: map['id'] as int,
        coordinate: List<int>.from(
          (map['coordinate'] as List<dynamic>).map((e) => e as int),
        ),
        imageCreatedAt: DateTime.parse(map['image_created_at'] as String),
        imageUrl: getImageUrl(
            map['image_bucket_id'] as String, map['image_name'] as String),
        imageId: map['image_id'] as String,
        imageName: map['image_name'] as String,
        imageBucketId: map['image_bucket_id'] as String,
        imageLabel:
            LabelResponse.fromJson(map['image_label'] as Map<String, dynamic>));
  }

  FaceModel copyWith({
    int? id,
    List<int>? coordinate,
    String? imageUrl,
    DateTime? imageCreatedAt,
    String? imageId,
    String? imageName,
    String? imageBucketId,
    LabelResponse? imageLabel,
  }) {
    return FaceModel(
      id: id ?? this.id,
      coordinate: coordinate ?? this.coordinate,
      imageUrl: imageUrl ?? this.imageUrl,
      imageCreatedAt: imageCreatedAt ?? this.imageCreatedAt,
      imageId: imageId ?? this.imageId,
      imageName: imageName ?? this.imageName,
      imageBucketId: imageBucketId ?? this.imageBucketId,
      imageLabel: imageLabel ?? this.imageLabel,
    );
  }
}
