import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';

class Song {
  final String name;
  final String artist;
  final String coverUrl;
  final String audioAssetPath;
  final MusicGenres genre;

  const Song(
      {required this.name,
      required this.artist,
      required this.coverUrl,
      required this.audioAssetPath,
      required this.genre});
}
