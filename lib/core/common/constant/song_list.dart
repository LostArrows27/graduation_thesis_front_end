import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/song.dart';

String albumPath(String albumName) {
  return 'assets/images/album_cover/$albumName';
}

String songPath(String songName) {
  return 'assets/music/$songName.mp3';
}

Map<MusicGenres, List<Song>> groupSongsByGenre(List<Song> songs) {
  Map<MusicGenres, List<Song>> groupedSongs = {};

  for (var song in songs) {
    if (groupedSongs.containsKey(song.genre)) {
      groupedSongs[song.genre]?.add(song);
    } else {
      groupedSongs[song.genre] = [song];
    }
  }

  return groupedSongs;
}

List<Song> songLists = [
  // accoutic
  Song(
      name: 'Accoustic Guitar',
      artist: "Oak Studio",
      coverUrl: albumPath('oak_studio.jpg'),
      audioAssetPath: songPath('accoutic_1'),
      genre: MusicGenres.accoutic),
  Song(
      name: 'Wild Nature',
      artist: "Infraction - NCS",
      coverUrl: albumPath('infraction.jpg'),
      audioAssetPath: songPath('accoutic_2'),
      genre: MusicGenres.accoutic),
  Song(
      name: 'Joy Rising',
      artist: "Infraction - NCS",
      coverUrl: albumPath('infraction.jpg'),
      audioAssetPath: songPath('accoutic_3'),
      genre: MusicGenres.accoutic),
  Song(
      name: 'Family',
      artist: "Infraction - NCS",
      coverUrl: albumPath('accoutic.jpg'),
      audioAssetPath: songPath('accoutic_4'),
      genre: MusicGenres.accoutic),
  Song(
      name: 'Last Easter',
      artist: "Infraction - NCS",
      coverUrl: albumPath('accoutic.jpg'),
      audioAssetPath: songPath('accoutic_5'),
      genre: MusicGenres.accoutic),
  Song(
      name: 'Happy Farm',
      artist: "Infraction - NCS",
      coverUrl: albumPath('accoutic.jpg'),
      audioAssetPath: songPath('accoutic_6'),
      genre: MusicGenres.accoutic),
  // emotional
  Song(
      name: '卒業',
      artist: "物語シリーズ",
      coverUrl: albumPath('monogatari.jpg'),
      audioAssetPath: songPath('emotional_1'),
      genre: MusicGenres.emotional),
  Song(
      name: 'Theme of Mitsuha',
      artist: "RADWIMPS",
      coverUrl: albumPath('your_name.jpg'),
      audioAssetPath: songPath('emotional_2'),
      genre: MusicGenres.emotional),
  Song(
      name: '夜明けの深呼吸',
      artist: "Akiyuki Tateyama",
      coverUrl: albumPath('akitate.jpg'),
      audioAssetPath: songPath('emotional_4'),
      genre: MusicGenres.emotional),
  Song(
      name: 'ゆるキャン△ Theme',
      artist: "Yuru Camp OST",
      coverUrl: albumPath('yuru_camp.jpg'),
      audioAssetPath: songPath('emotional_5'),
      genre: MusicGenres.emotional),
  Song(
      name: '打ち上げ花火',
      artist: "fox capture plan",
      coverUrl: albumPath('fox_capture_plan.jpg'),
      audioAssetPath: songPath('emotional_3'),
      genre: MusicGenres.emotional),
  Song(
      name: 'Chilhood',
      artist: "Scott Buckley",
      coverUrl: albumPath('scott.jpg'),
      audioAssetPath: songPath('emotional_6'),
      genre: MusicGenres.emotional),
  // folk
  Song(
      name: 'Wake Up',
      artist: "Infraction - NCS",
      coverUrl: albumPath('folk.jpg'),
      audioAssetPath: songPath('folk_1'),
      genre: MusicGenres.folk),
  Song(
      name: 'Campfire',
      artist: "Roa",
      coverUrl: albumPath('roa.jpg'),
      audioAssetPath: songPath('folk_2'),
      genre: MusicGenres.folk),
  Song(
      name: 'Joy Rising',
      artist: "Infraction - NCS",
      coverUrl: albumPath('folk.jpg'),
      audioAssetPath: songPath('folk_3'),
      genre: MusicGenres.folk),
  Song(
      name: 'Letting Go',
      artist: "Infraction - NCS",
      coverUrl: albumPath('folk.jpg'),
      audioAssetPath: songPath('folk_4'),
      genre: MusicGenres.folk),
  Song(
      name: 'Part Of Life',
      artist: "Infraction - NCS",
      coverUrl: albumPath('folk.jpg'),
      audioAssetPath: songPath('folk_5'),
      genre: MusicGenres.folk),
  Song(
      name: 'Happy Foods',
      artist: "Infraction - NCS",
      coverUrl: albumPath('folk.jpg'),
      audioAssetPath: songPath('folk_6'),
      genre: MusicGenres.folk),
  // happy
  Song(
      name: 'Santa',
      artist: "Infraction - NCS",
      coverUrl: albumPath('emotional.jpg'),
      audioAssetPath: songPath('happy_1'),
      genre: MusicGenres.happy),
  Song(
      name: 'Christmas Night',
      artist: "Infraction - NCS",
      coverUrl: albumPath('emotional.jpg'),
      audioAssetPath: songPath('happy_2'),
      genre: MusicGenres.happy),
  Song(
      name: 'Cheerful',
      artist: "Alexi Action",
      coverUrl: albumPath('emotional.jpg'),
      audioAssetPath: songPath('happy_3'),
      genre: MusicGenres.happy),
  Song(
      name: 'Good Days',
      artist: "Infraction - NCS",
      coverUrl: albumPath('happy.jpg'),
      audioAssetPath: songPath('happy_4'),
      genre: MusicGenres.happy),
  Song(
      name: 'Take Your Time',
      artist: "Infraction - NCS",
      coverUrl: albumPath('happy.jpg'),
      audioAssetPath: songPath('happy_5'),
      genre: MusicGenres.happy),
  Song(
      name: 'Whistle Kid',
      artist: "Infraction - NCS",
      coverUrl: albumPath('happy.jpg'),
      audioAssetPath: songPath('happy_6'),
      genre: MusicGenres.happy),
];
