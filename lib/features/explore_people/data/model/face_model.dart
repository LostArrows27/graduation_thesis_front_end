import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';

class FaceModel extends Face {
  FaceModel(
      {required super.id,
      required super.coordinate,
      required super.imageUrl,
      required super.imageCreatedAt});

  factory FaceModel.fromJson(Map<String, dynamic> map) {
    return FaceModel(
        id: map['id'] as int,
        coordinate: List<int>.from(
          (map['coordinate'] as List<dynamic>).map((e) => e as int),
        ),
        imageCreatedAt: DateTime.parse(map['image_created_at'] as String),
        imageUrl: map['image_url'] as String);
  }
}
