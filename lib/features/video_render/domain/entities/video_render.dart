class VideoRender {
  final String id;
  final String status;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? thumbnailUrl;
  final String? title;

  VideoRender(
      {required this.id,
      required this.status,
      this.thumbnailUrl,
      this.title,
      required this.progress,
      required this.createdAt,
      required this.updatedAt});

  factory VideoRender.fromJson(Map<String, dynamic> map) {
    return VideoRender(
      id: map['id'] as String,
      status: map['status'] as String,
      progress: (map['progress'] as num).toInt(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      thumbnailUrl:
          map['thumbnail_url'] != null ? map['thumbnail_url'] as String : null,
      // title: scene->introScene->firstScene->title
      title: map['title'] != null ? map['title'] as String : null,
    );
  }
}
