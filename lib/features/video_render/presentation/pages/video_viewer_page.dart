import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/theme/app_theme.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_chunk.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_chunk/video_chunk_bloc.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String videoRenderId;

  const VideoViewer({super.key, required this.videoRenderId});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<VideoChunkBloc>(),
      child: VideoViewerBody(videoRenderId: widget.videoRenderId),
    );
  }
}

class VideoViewerBody extends StatefulWidget {
  final String videoRenderId;

  const VideoViewerBody({
    super.key,
    required this.videoRenderId,
  });

  @override
  State<VideoViewerBody> createState() => _VideoViewerBodyState();
}

class _VideoViewerBodyState extends State<VideoViewerBody> {
  VideoChunk? videoChunks;

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    context
        .read<VideoChunkBloc>()
        .add(GetAllChunk(videoRenderId: widget.videoRenderId));
  }

  @override
  void dispose() {
    _disposePage();
    super.dispose();
  }

  void _disposePage() {
    context.read<VideoChunkBloc>().close();
    _videoPlayerController.pause();
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    _chewieController!.dispose();
  }

  Future<void> initializePlayer(String url) async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await _videoPlayerController.initialize();

      _createChewieController();
      setState(() {});
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Theme.of(context).primaryColor,
        handleColor: Colors.white,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.black26,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark.copyWith(platform: TargetPlatform.android),
      child: BlocConsumer<VideoChunkBloc, VideoChunkState>(
        listener: (context, state) {
          if (state is VideoChunkError) {
            return showErrorSnackBar(context, state.message);
          }

          if (state is VideoChunkSuccess) {
            setState(() {
              videoChunks = state.videoChunks;
            });

            initializePlayer(state.videoChunks.url);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: _chewieController == null || state is VideoChunkLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 6.0,
                    ),
                  )
                : Stack(children: [
                    Center(
                      child: Chewie(controller: _chewieController!),
                    ),
                    Positioned(
                      top: 45,
                      left: 5,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _disposePage();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ]),
          );
        },
      ),
    );
  }
}
