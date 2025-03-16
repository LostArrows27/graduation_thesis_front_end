import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_render_progress.dart/video_render_progress_bloc.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VideoRenderResultPage extends StatelessWidget {
  final String videoRenderId;

  const VideoRenderResultPage({super.key, required this.videoRenderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VideoRenderProgressBloc>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                context.go(Routes.photosPage);
              },
            ),
            SizedBox(width: 5),
          ],
        ),
        body: Center(
          child: VideoProgressBody(videoRenderId: videoRenderId),
        ),
      ),
    );
  }
}

class VideoProgressBody extends StatefulWidget {
  final String videoRenderId;

  const VideoProgressBody({
    super.key,
    required this.videoRenderId,
  });

  @override
  State<VideoProgressBody> createState() => _VideoProgressBodyState();
}

class _VideoProgressBodyState extends State<VideoProgressBody> {
  double _progress = 0;
  late VideoRenderProgressBloc _videoBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the bloc
    _videoBloc = context.read<VideoRenderProgressBloc>();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoBloc.add(
          ListenVideoRenderProgressEvent(videoRenderId: widget.videoRenderId));
      _videoBloc
          .add(FirstFetchVideoProgress(videoRenderId: widget.videoRenderId));
    });
  }

  @override
  void dispose() {
    // Use the stored reference instead of context.read()
    _videoBloc.add(
      UnSubcribeToVideoRenderChannel(
          channelName: 'video_render_preview:${widget.videoRenderId}'),
    );
    super.dispose();
  }

  String _getLottieAsset(VideoRenderProgressState state) {
    if (state is VideoRenderProgressSuccess) {
      return 'assets/lottie/video_done.json';
    } else if (state is VideoRenderProgressFailure) {
      return 'assets/lottie/video_fail.json';
    } else {
      return 'assets/lottie/video_loading.json';
    }
  }

  String _getTitle(VideoRenderProgressState state) {
    if (state is VideoRenderProgressSuccess) {
      return "Congrats!";
    } else if (state is VideoRenderProgressFailure) {
      return "Oops!";
    } else {
      return "Hold Up!";
    }
  }

  String _getDescription(VideoRenderProgressState state) {
    if (state is VideoRenderProgressSuccess) {
      return "Your video has been successfully rendered.\nClick button below.";
    } else if (state is VideoRenderProgressFailure) {
      return "Failed to render video. Please try again.";
    } else {
      return "Please wait while your video is\nbeing processed - $_progress%";
    }
  }

  Widget _failedWidget() {
    return Center(
        child: Column(
      children: [
        SizedBox(height: 100),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset('assets/images/wrong.webp', width: 350),
        ),
        SizedBox(height: 50),
        Text(
          "OOPS !",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary),
        ),
        SizedBox(height: 20),
        Text(
          "Failed to fetch video render status",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 15),
        FilledButton(
          onPressed: () {
            context.read<VideoRenderProgressBloc>().add(
                FirstFetchVideoProgress(videoRenderId: widget.videoRenderId));
          },
          child: Text("Retry"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoRenderProgressBloc, VideoRenderProgressState>(
      listener: (context, state) {
        if (state is VideoRenderProgressUpdate) {
          return setState(() {
            _progress = state.progress.toDouble();
          });
        }

        if (state is VideoRenderProgressSuccess) {
          setState(() {
            _progress = 100;
          });
        }
      },
      builder: (context, state) {
        if (state is VideoRenderProgressLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is VideoRenderProgressFailure) {
          return _failedWidget();
        }

        return Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Container(
                    child: Lottie.asset(_getLottieAsset(state),
                        width: double.infinity, height: 300),
                  ),
                  SizedBox(height: 14),
                  Text(
                    _getTitle(state),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _getDescription(state),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        animation: true,
                        percent: _progress / 100,
                        animateFromLastPercent: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryFixed,
                        progressColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 250,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (state is VideoRenderProgressSuccess) {
                          context.push(Routes.videoViewerPage,
                              extra: widget.videoRenderId);
                        }

                        if (state is VideoRenderProgressUpdate ||
                            state is VideoRenderProgressInitial) {
                          context.push(Routes.videoRenderStatusPage);
                        }
                      },
                      child: Text("See Render Result",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
