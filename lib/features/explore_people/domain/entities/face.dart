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
  final String? name;

  Face(
      {required this.id,
      required this.coordinate,
      this.name,
      required this.imageUrl,
      required this.imageId,
      required this.imageName,
      required this.imageBucketId,
      required this.imageLabel,
      required this.imageCreatedAt});

  Face copyWith({
    int? id,
    List<int>? coordinate,
    String? imageUrl,
    DateTime? imageCreatedAt,
    String? imageId,
    String? imageName,
    String? imageBucketId,
    LabelResponse? imageLabel,
    String? name,
  }) {
    return Face(
      id: id ?? this.id,
      coordinate: coordinate ?? this.coordinate,
      imageUrl: imageUrl ?? this.imageUrl,
      imageCreatedAt: imageCreatedAt ?? this.imageCreatedAt,
      imageId: imageId ?? this.imageId,
      imageName: imageName ?? this.imageName,
      imageBucketId: imageBucketId ?? this.imageBucketId,
      imageLabel: imageLabel ?? this.imageLabel,
      name: name ?? this.name,
    );
  }
}
