import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/entities/label.dart';

class ImageModel extends Photo {
  ImageModel(
      {required super.id,
      super.createdAt,
      super.updatedAt,
      super.imageUrl,
      super.caption,
      super.longitude,
      super.latitude,
      super.locationMetaData,
      required super.isFavorite,
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
      caption: json['caption'] as String?,
      labels: json['labels'] == null
          ? LabelResponse(
              labels:
                  Labels(locationLabels: [], actionLabels: [], eventLabels: []))
          : LabelResponse.fromJson(json['labels'] as Map<String, dynamic>),
      imageUrl: json['image_url'] == null ? null : json['image_url'] as String,
      isFavorite: json['is_favorite'] as bool,
      longitude: json['longitude'] == null
          ? null
          : (json['longitude'] as num).toDouble(),
      latitude: json['latitude'] == null
          ? null
          : (json['latitude'] as num).toDouble(),
      locationMetaData: json['location_meta_data'] == null
          ? null
          : Placemark.fromMap(
              json['location_meta_data'] as Map<String, dynamic>),
    );
  }

  @override
  ImageModel copyWith(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? uploaderId,
      String? imageBucketId,
      String? imageName,
      LabelResponse? labels,
      String? imageUrl,
      bool? isFavorite,
      double? longitude,
      double? latitude,
      Placemark? locationMetaData,
      String? caption}) {
    return ImageModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        uploaderId: uploaderId ?? this.uploaderId,
        imageBucketId: imageBucketId ?? this.imageBucketId,
        imageName: imageName ?? this.imageName,
        labels: labels ?? this.labels,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        locationMetaData: locationMetaData ?? this.locationMetaData,
        caption: caption ?? this.caption);
  }
}
