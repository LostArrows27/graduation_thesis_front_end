import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_axis_cell_count.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/delete_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';

class AlbumViewerPage extends StatefulWidget {
  final String title;
  final int totalItem;
  final List<AlbumFolder> albumFolders;
  final String heroTag;

  const AlbumViewerPage(
      {super.key,
      required this.title,
      required this.totalItem,
      required this.albumFolders,
      required this.heroTag});

  @override
  State<AlbumViewerPage> createState() => _AlbumViewerPageState();
}

class _AlbumViewerPageState extends State<AlbumViewerPage> {
  List<AlbumFolder> albumFolders = [];

  @override
  void initState() {
    super.initState();
    albumFolders = widget.albumFolders;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCaptionBloc, EditCaptionState>(
      listener: (context, state) {
        if (state is EditCaptionFailure) {
          return showErrorSnackBar(context, state.message);
        }

        if (state is EditCaptionSuccess) {
          final caption = state.caption;
          final imageId = state.imageId;

          setState(() {
            for (var folder in albumFolders) {
              final photoList = folder.photos;
              final index =
                  photoList.indexWhere((element) => element.id == imageId);

              if (index != -1) {
                photoList[index] = photoList[index].copyWith(caption: caption);
              }
            }
          });
        }
      },
      child: BlocListener<DeleteImageCubit, DeleteImageCubitState>(
        listener: (context, state) {
          if (state is DeleteImageCubitError) {
            return showErrorSnackBar(context, state.message);
          }

          if (state is DeleteImageCubitSuccess) {
            final imageBucketId = state.imageBucketId;
            final imageName = state.imageName;
            bool imageDeleted = false;

            setState(() {
              List<AlbumFolder> updatedFolders = [];

              for (var folder in albumFolders) {
                final photoList = folder.photos;
                final index = photoList.indexWhere((element) =>
                    element.imageBucketId == imageBucketId &&
                    element.imageName == imageName);

                if (index != -1) {
                  photoList.removeAt(index);
                  imageDeleted = true;

                  if (photoList.isNotEmpty) {
                    updatedFolders.add(folder);
                  }
                } else {
                  updatedFolders.add(folder);
                }
              }

              albumFolders = updatedFolders;
            });

            if (imageDeleted) {
              if (albumFolders.isEmpty) {
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.pop(context);
                });
              }
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${widget.totalItem} photos',
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final folderTitle = albumFolders[index].title;
                      final photoList = albumFolders[index].photos;

                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              folderTitle,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            SizedBox(height: 20),
                            StaggeredGrid.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                ...photoList.asMap().map((index, photo) {
                                  final [crossAxisCount, mainAxisCount] =
                                      convertAxisCellCount(
                                          index, photoList.length);
                                  return MapEntry(
                                    index,
                                    StaggeredGridTile.count(
                                        crossAxisCellCount: crossAxisCount,
                                        mainAxisCellCount: mainAxisCount,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.push(Routes.imageSliderPage,
                                                extra: {
                                                  'url': photo.imageUrl,
                                                  'images':
                                                      getAllPhotoFromGroupImage(
                                                          albumFolders),
                                                  'heroTag': widget.heroTag
                                                });
                                          },
                                          child: HeroNetworkImage(
                                              borderRadius: 15,
                                              imageUrl: photo.imageUrl!,
                                              heroTag: photo.imageUrl! +
                                                  widget.heroTag),
                                        )),
                                  );
                                }).values
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: albumFolders.length)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
