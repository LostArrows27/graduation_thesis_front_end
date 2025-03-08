import 'dart:io';

class PhotoFile {
  final File file;
  final DateTime? dateTime;

  const PhotoFile({
    required this.file,
    this.dateTime,
  });
}
