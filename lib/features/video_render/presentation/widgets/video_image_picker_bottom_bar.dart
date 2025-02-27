import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/bloc/video_render_schema/video_render_schema_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/selected_image_preview.dart';

class VideoImagePickerBottomBar extends StatefulWidget {
  final ImageProviderModel imageProvider;

  const VideoImagePickerBottomBar({
    super.key,
    required this.imageProvider,
  });

  @override
  State<VideoImagePickerBottomBar> createState() =>
      _VideoImagePickerBottomBarState();
}

class _VideoImagePickerBottomBarState extends State<VideoImagePickerBottomBar> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoRenderSchemaBloc, VideoRenderSchemaState>(
      listener: (context, state) {
        if (state is VideoRenderSchemaFailure) {
          return showSnackBar(context, state.message);
        }

        if (state is VideoRenderSchemaSuccess) {
          context.push(Routes.editVideoSchemaPage, extra: state.videoSchema);
        }
      },
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            height: 170,
            child: SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add or remove image',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        FilledButton(
                          onPressed: widget
                                      .imageProvider.getImageList.isEmpty ||
                                  state is VideoRenderSchemaLoading
                              ? null
                              : () {
                                  final photoState =
                                      (context.read<PhotoBloc>().state);

                                  if (photoState is! PhotoFetchSuccess) {
                                    return showSnackBar(context,
                                        'Please wait until all images are loaded');
                                  }

                                  final offlineImageList = widget
                                      .imageProvider.getImageList
                                      .where((element) =>
                                          element.source == Source.offline)
                                      .toList();

                                  final onlineImageUrl = widget
                                      .imageProvider.getImageList
                                      .where((element) =>
                                          element.source == Source.online)
                                      .map((e) => e.filePath)
                                      .toList();

                                  final onlineImageIdList = photoState.photos
                                      .where((element) => onlineImageUrl
                                          .contains(element.imageUrl))
                                      .map((e) => e.id)
                                      .toList();

                                  final userId = (context
                                          .read<AppUserCubit>()
                                          .state as AppUserLoggedIn)
                                      .user
                                      .id;

                                  context.read<VideoRenderSchemaBloc>().add(
                                      GetVideoSchemaEvent(
                                          offlineImagesList: offlineImageList,
                                          onlineImageIdList: onlineImageIdList,
                                          userId: userId));
                                },
                          style: FilledButton.styleFrom(
                            minimumSize: Size(30, 35),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                          ),
                          child: Text('Import'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 92,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageProvider.getImageList.length,
                      itemBuilder: (context, index) {
                        return SelectedImagePreview(
                          removeImage: (url) {
                            widget.imageProvider.removeImage(url);
                          },
                          isLoading: state is VideoRenderSchemaLoading,
                          index: index,
                          image: widget.imageProvider.getImageList[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
