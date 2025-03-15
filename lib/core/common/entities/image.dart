// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geocoding/geocoding.dart';
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
  final bool isFavorite;
  final double? longitude;
  final double? latitude;
  final Placemark? locationMetaData;

  Photo(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.caption,
      this.longitude,
      this.latitude,
      this.locationMetaData,
      required this.uploaderId,
      required this.imageBucketId,
      required this.isFavorite,
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
    bool? isFavorite,
    double? longitude,
    double? latitude,
    Placemark? locationMetaData,
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
      isFavorite: isFavorite ?? this.isFavorite,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      locationMetaData: locationMetaData ?? this.locationMetaData,
    );
  }
}
