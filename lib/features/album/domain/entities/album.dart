// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';

class Album {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final List<Photo> imageList;
  final List<String> imageIdList;

  Album(
      {required this.id,
      required this.ownerId,
      required this.createdAt,
      required this.updatedAt,
      required this.imageList,
      required this.imageIdList,
      required this.name});

  Album copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    List<Photo>? imageList,
    List<String>? imageIdList,
  }) {
    return Album(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      imageList: imageList ?? this.imageList,
      imageIdList: imageIdList ?? this.imageIdList,
    );
  }
}
