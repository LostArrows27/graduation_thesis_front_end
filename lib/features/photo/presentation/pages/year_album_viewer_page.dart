import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_axis_cell_count.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/year_album_folder.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/delete_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';

class YearAlbumViewerPage extends StatefulWidget {
  final String title;
  final int totalItem;
  final List<YearAlbumFolder> yearAlbumFolders;

  static const String heroTag = 'year_album_viewer_tags';

  const YearAlbumViewerPage({
    super.key,
    required this.title,
    required this.totalItem,
    required this.yearAlbumFolders,
  });

  @override
  State<YearAlbumViewerPage> createState() => _YearAlbumViewerPageState();
}

class _YearAlbumViewerPageState extends State<YearAlbumViewerPage> {
  List<YearAlbumFolder> yearAlbumFolders = [];

  @override
  void initState() {
    super.initState();
    yearAlbumFolders = widget.yearAlbumFolders;
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
            bool photoUpdated = false;

            for (var yearFolder in yearAlbumFolders) {
              if (photoUpdated) break;

              for (var albumFolder in yearFolder.folderList) {
                if (photoUpdated) break;

                for (int photoIndex = 0;
                    photoIndex < albumFolder.photos.length;
                    photoIndex++) {
                  final photo = albumFolder.photos[photoIndex];

                  if (photo.id == imageId) {
                    albumFolder.photos[photoIndex] =
                        photo.copyWith(caption: caption);
                    photoUpdated = true;
                    break;
                  }
                }
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
            setState(() {
              bool imageRemoved = false;

              for (var yearFolder in yearAlbumFolders) {
                if (imageRemoved) break;

                for (int folderIndex = 0;
                    folderIndex < yearFolder.folderList.length;
                    folderIndex++) {
                  var albumFolder = yearFolder.folderList[folderIndex];

                  final photoIndex = albumFolder.photos.indexWhere((photo) =>
                      photo.imageBucketId == state.imageBucketId &&
                      photo.imageName == state.imageName);

                  if (photoIndex != -1) {
                    albumFolder.photos.removeAt(photoIndex);
                    imageRemoved = true;
                    break;
                  }
                }
              }
            });
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
                      itemBuilder: (context, yearIndex) {
                        final yearFolder = yearAlbumFolders[yearIndex];
                        final folderList = yearFolder.folderList;

                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                yearFolder.bigTitle,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 20),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, folderIndex) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          folderList[folderIndex].title,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                        ),
                                        SizedBox(height: 20),
                                        StaggeredGrid.count(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          children: [
                                            ...folderList[folderIndex]
                                                .photos
                                                .asMap()
                                                .map((index, photo) {
                                              final [
                                                crossAxisCount,
                                                mainAxisCount
                                              ] = convertAxisCellCount(
                                                  index,
                                                  folderList[folderIndex]
                                                      .photos
                                                      .length);
                                              return MapEntry(
                                                index,
                                                StaggeredGridTile.count(
                                                    crossAxisCellCount:
                                                        crossAxisCount,
                                                    mainAxisCellCount:
                                                        mainAxisCount,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        context.push(
                                                            Routes
                                                                .imageSliderPage,
                                                            extra: {
                                                              'url': photo
                                                                  .imageUrl,
                                                              'heroTag':
                                                                  YearAlbumViewerPage
                                                                      .heroTag,
                                                              'images':
                                                                  getAllPhotoFromYearAlbum(
                                                                      yearAlbumFolders)
                                                            });
                                                      },
                                                      child: HeroNetworkImage(
                                                          borderRadius: 15,
                                                          imageUrl:
                                                              photo.imageUrl!,
                                                          heroTag: photo
                                                                  .imageUrl! +
                                                              YearAlbumViewerPage
                                                                  .heroTag),
                                                    )),
                                              );
                                            }).values
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                  itemCount: folderList.length)
                            ],
                          ),
                        );
                      },
                      itemCount: yearAlbumFolders.length)
                ],
              ),
            )),
      ),
    );
  }
}
