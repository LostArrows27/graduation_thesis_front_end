import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/loader.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/relative_time_covert.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/video_render.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/render_status/render_status_bloc.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

class VideoRenderStatusPage extends StatelessWidget {
  const VideoRenderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => serviceLocator<RenderStatusBloc>(),
        child: VideoRenderPageLayout());
  }
}

class VideoRenderPageLayout extends StatelessWidget {
  const VideoRenderPageLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              context.go(Routes.photosPage);
            },
          ),
          title: Text(
            'Recap Video Status',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                context.read<RenderStatusBloc>().add(FetchAllRender());
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add photo to your video',
          onPressed: () {
            // NOTE: un-comment for dev process
            // context.push(Routes.editVideoSchemaPage, extra: fakeVideoSchema);
            context.push(Routes.videoImagePickerPage);
          },
          child: Icon(Icons.add_photo_alternate_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: RenderStatusList()));
  }
}

class RenderStatusList extends StatefulWidget {
  const RenderStatusList({super.key});

  @override
  State<RenderStatusList> createState() => _RenderStatusListState();
}

class _RenderStatusListState extends State<RenderStatusList> {
  List<VideoRender> videoRenderList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RenderStatusBloc>().add(FetchAllRender());
      context.read<RenderStatusBloc>().add(ListenRenderListChange());
    });
  }

  @override
  void dispose() {
    context.read<RenderStatusBloc>().add(UnSubcribeToRenderListChannel());
    super.dispose();
  }

  Color _getProgressColor(int progress, String status) {
    if (status == 'failed') {
      return Colors.redAccent;
    }

    if (status == 'completed') {
      return Colors.greenAccent;
    }

    if (status == 'in_progress') {
      return Colors.orangeAccent;
    }

    return Colors.amberAccent;
  }

  Widget _buildStatusString(String status) {
    switch (status) {
      case "pending":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_top_sharp, size: 18, color: Colors.amber),
            SizedBox(width: 5),
            Text("Pending",
                style: TextStyle(fontSize: 12, color: Colors.amber)),
          ],
        );
      case "in_progress":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.watch_later_rounded, size: 18, color: Colors.orange),
            SizedBox(width: 5),
            Text("Uploading",
                style: TextStyle(fontSize: 12, color: Colors.orange)),
          ],
        );
      case "failed":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, size: 18, color: Colors.red),
            SizedBox(width: 5),
            Text("Failed", style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
        );
      case "completed":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 18, color: Colors.green),
            SizedBox(width: 5),
            Text("Completed",
                style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        );
      default:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_top_sharp, size: 18, color: Colors.orange),
            SizedBox(width: 5),
            Text("Pending",
                style: TextStyle(fontSize: 12, color: Colors.orange)),
          ],
        );
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
            context.read<RenderStatusBloc>().add(FetchAllRender());
          },
          child: Text("Retry"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RenderStatusBloc, RenderStatusState>(
      listener: (context, state) {
        if (state is FetchRenderSuccess) {
          return setState(() {
            videoRenderList = state.renderStatus;
          });
        }

        if (state is RenderListUpdateState) {
          final updatedRenderComp = state.changedRenderComp;

          final index = videoRenderList
              .indexWhere((element) => element.id == updatedRenderComp.id);

          if (index != -1) {
            setState(() {
              videoRenderList[index] = updatedRenderComp;
            });
          }
        }
      },
      builder: (context, state) {
        if (state is FetchRenderLoading || state is RenderStatusInitial) {
          return Loader();
        }

        if (state is FetchRenderFailure) {
          return _failedWidget();
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final videoRender = videoRenderList[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: 190,
                      height: 120,
                      decoration: BoxDecoration(
                        color: videoRender.thumbnailUrl != null
                            ? null
                            : Theme.of(context).colorScheme.outlineVariant,
                        image: videoRender.thumbnailUrl != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    videoRender.thumbnailUrl!))
                            : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              height: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black12,
                                onTap: () {
                                  context.push(Routes.videoRenderResult,
                                      extra: videoRender.id);
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(Routes.videoRenderResult,
                                  extra: videoRender.id);
                            },
                            child: Center(
                              child: Text(
                                "${videoRender.progress}%",
                                style: TextStyle(
                                    color: _getProgressColor(
                                        videoRender.progress,
                                        videoRender.status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoRender.title ?? "No title video",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(
                        relativeTimeConvert(videoRender.createdAt),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 30),
                      _buildStatusString(videoRender.status),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                    onTap: () {
                      //  TODO: open bottom option menu
                    },
                    child: Icon(Icons.more_vert, size: 24)),
              ],
            );
          },
          itemCount: videoRenderList.length,
        );
      },
    );
  }
}

// NOTE: remove duplicate image
