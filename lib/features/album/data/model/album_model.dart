import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';

class AlbumModel extends Album {
  AlbumModel(
      {required super.id,
      required super.imageIdList,
      required super.ownerId,
      required super.createdAt,
      required super.updatedAt,
      required super.imageList,
      required super.name});

  AlbumModel copyWith(
      {String? id,
      String? ownerId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? name,
      List<Photo>? imageList,
      List<String>? imageIdList}) {
    return AlbumModel(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        imageList: imageList ?? this.imageList,
        imageIdList: imageIdList ?? this.imageIdList);
  }
}
