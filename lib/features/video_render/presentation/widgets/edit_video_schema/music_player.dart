import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/song.dart';

class MusicPlayer extends StatefulWidget {
  final Song? selectedSong;

  const MusicPlayer({super.key, required this.selectedSong});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.audioCache = AudioCache(prefix: '');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playMusic() async {
    if (_audioPlayer.state == PlayerState.paused) {
      await _audioPlayer.resume();
    } else if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.selectedSong!.audioAssetPath));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void didUpdateWidget(MusicPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedSong?.audioAssetPath !=
        oldWidget.selectedSong?.audioAssetPath) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(widget.selectedSong!.coverUrl)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.selectedSong!.name,
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.selectedSong!.artist,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHigh),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                IconButton.filled(
                    onPressed: _playMusic,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow))
              ],
            ),
          )),
    );
  }
}
