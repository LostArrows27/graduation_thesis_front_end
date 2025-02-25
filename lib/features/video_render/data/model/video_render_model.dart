import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';

class VideoRenderModel extends VideoRender {
  VideoRenderModel(
      {required super.id,
      required super.status,
      required super.progress,
      required super.createdAt,
      required super.updatedAt});

  factory VideoRenderModel.fromMap(Map<String, dynamic> map) {
    return VideoRenderModel(
      id: map['id'] as String,
      status: map['status'] as String,
      progress: map['progress'] as int,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
