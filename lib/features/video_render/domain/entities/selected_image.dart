enum Source { online, offline }

class SelectedImage {
  final String filePath;
  final Source source;

  SelectedImage({required this.filePath, required this.source});
}
