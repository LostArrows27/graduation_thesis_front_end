import 'package:graduation_thesis_front_end/core/common/constant/song_list.dart';
// import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/song.dart';

Song convertStringToSong(String songString) {
  // cut /music/intro/emotional_2.mp3 -> emotional_2.mp3

  final songName = songString.split('/').last;

  return songLists.firstWhere(
      (element) => element.audioAssetPath.split('/').last == songName);
}

// MusicGenres fromStringToMusicGenres(String genre) {
//   switch (genre) {
//     case 'accoutic':
//       return MusicGenres.accoutic;
//     case 'folk':
//       return MusicGenres.folk;
//     case 'happy':
//       return MusicGenres.happy;
//     case 'emotional':
//       return MusicGenres.emotional;
//     default:
//       return MusicGenres.happy;
//   }
// }
