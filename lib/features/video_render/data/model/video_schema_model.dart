import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_schema.dart';

class VideoSchemaModel extends VideoSchema {
  VideoSchemaModel(
      {required super.videoRenderId,
      required super.videoTitle,
      required super.titleStyle,
      required super.bgMusic,
      required super.bgVideoTheme,
      super.thumbnailUrl,
      super.maxDuration});

  factory VideoSchemaModel.fromJson(Map<String, dynamic> map) {
    return VideoSchemaModel(
      videoRenderId: map['videoRenderId'] as String,
      videoTitle: map['videoTitle'] as String,
      titleStyle: map['titleStyle'] as int,
      bgMusic: map['bgMusic'] as String,
      bgVideoTheme: map['bgVideoTheme'] as String,
      maxDuration:
          map['maxDuration'] == null ? null : map['maxDuration'] as int,
      thumbnailUrl:
          map['thumbnailUrl'] == null ? null : map['thumbnailUrl'] as String,
    );
  }
}
