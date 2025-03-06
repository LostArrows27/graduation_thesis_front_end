class Face {
  final int id;
  final List<int> coordinate;
  final String imageUrl;
  final DateTime imageCreatedAt;

  Face(
      {required this.id,
      required this.coordinate,
      required this.imageUrl,
      required this.imageCreatedAt});
}
