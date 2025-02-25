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
}
