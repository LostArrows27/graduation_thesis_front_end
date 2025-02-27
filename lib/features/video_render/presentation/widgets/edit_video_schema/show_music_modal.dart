import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/constant/song_list.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/song.dart';

void showMusicModal(
    BuildContext context, Song selectedSong, Function(Song) onSongSelected) {
  final groupedSongs = groupSongsByGenre(songLists);

  ScrollController scrollController = ScrollController();

  int selectedSongIndex = -1;
  bool found = false;

  for (var genre in groupedSongs.keys) {
    for (var song in groupedSongs[genre]!) {
      selectedSongIndex++;
      if (song.audioAssetPath == selectedSong.audioAssetPath) {
        found = true;
        break;
      }
    }
    if (found) {
      break;
    }
  }

  Future.delayed(Duration(milliseconds: 80), () {
    if (selectedSongIndex != -1) {
      scrollController.jumpTo(
          selectedSongIndex * 100 > 1920 ? 1920 : selectedSongIndex * 100);
    }
  });

  Widget itemBuilder(BuildContext context, int index) {
    List<Song> songs = groupedSongs.values.elementAt(index);

    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupedSongs.keys.elementAt(index).name.capitalize,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ...songs.map((song) {
          bool isSelected = song.audioAssetPath == selectedSong.audioAssetPath;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    onSongSelected(song);
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(song.coverUrl)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 90,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        song.name,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        song.artist,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHigh),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            isSelected
                                ? IconButton.filled(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.play_arrow,
                                    ))
                                : Container()
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(height: 15)
            ],
          );
        })
      ],
    ));
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 600,
          width: 660,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 550,
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: itemBuilder,
                    itemCount: groupedSongs.keys.length,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
