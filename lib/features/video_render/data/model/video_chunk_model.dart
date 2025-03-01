import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_chunk.dart';

class VideoChunkModel extends VideoChunk {
  VideoChunkModel(
      {required super.id, required super.url});

  factory VideoChunkModel.fromJson(Map<String, dynamic> json) {
    return VideoChunkModel(
      id: json['id'],
      url: json['url'] ?? '',
    );
  }

  // copy with
  VideoChunkModel copyWith({
    String? id,
    String? url,
  }) {
    return VideoChunkModel(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }
}
