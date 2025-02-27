class VideoRender {
  final String id;
  final String status;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  VideoRender(
      {required this.id,
      required this.status,
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
    );
  }
}
