import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/convert_axis_cell_count.dart';
import 'package:graduation_thesis_front_end/core/utils/dowload_image.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_network_image.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/change_album_name_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/delete_album_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/delete_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/favorite_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/edit_album_name_modal.dart';

class AlbumViewerPage extends StatefulWidget {
  final String title;
  final int totalItem;
  final List<AlbumFolder> albumFolders;
  final String heroTag;
  final String? albumId;

  const AlbumViewerPage(
      {super.key,
      required this.title,
      this.albumId,
      required this.totalItem,
      required this.albumFolders,
      required this.heroTag});

  @override
  State<AlbumViewerPage> createState() => _AlbumViewerPageState();
}

class _AlbumViewerPageState extends State<AlbumViewerPage> {
  List<AlbumFolder> albumFolders = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    albumFolders = widget.albumFolders;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteAlbumCubit, DeleteAlbumState>(
          listener: (context, state) {
            if (widget.albumId == null) return;

            if (state is DeleteAlbumError) {
              return showErrorSnackBar(context, state.message);
            }

            if (state is DeleteAlbumSuccess) {
              showSnackBar(context, 'Album removed successfully');
              context.pop();
            }
          },
        ),
        BlocListener<ChangeAlbumNameCubit, ChangeAlbumNameState>(
          listener: (context, state) {
            if (widget.albumId == null) return;

            if (state is ChangeAlbumNameError) {
              return showErrorSnackBar(context, state.message);
            }

            if (state is ChangeAlbumNameSuccess) {
              showSnackBar(context, 'Album name changed successfully');
              setState(() {
                title = state.newAlbumName;
              });
              return;
            }
          },
        ),
        BlocListener<FavoriteImageCubit, FavoriteImageState>(
            listener: (context, favoriteState) {
          if (favoriteState is FavoriteImageError) {
            return showErrorSnackBar(context, favoriteState.message);
          }

          if (favoriteState is FavoriteImageSuccess) {
            final imageId = favoriteState.imageId;
            final isFavorite = favoriteState.isFavorite;

            setState(() {
              for (var folder in albumFolders) {
                final photoList = folder.photos;
                final index =
                    photoList.indexWhere((element) => element.id == imageId);

                if (index != -1) {
                  photoList[index] =
                      photoList[index].copyWith(isFavorite: isFavorite);
                }
              }
            });
          }
        }),
        BlocListener<EditCaptionBloc, EditCaptionState>(
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
                  photoList[index] =
                      photoList[index].copyWith(caption: caption);
                }
              }
            });
          }
        }),
        BlocListener<DeleteImageCubit, DeleteImageCubitState>(
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
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                });
              }
            }
          }
        })
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            PopupMenuButton<Menu>(
              icon: const Icon(Icons.more_vert),
              onSelected: (Menu item) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.edit,
                  enabled: widget.albumId != null,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit'),
                    onTap: widget.albumId != null
                        ? () async {
                            await openEditAlbumNameModal(
                                context, title, widget.albumId!);

                            context.pop();
                          }
                        : null,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<Menu>(
                  onTap: () async {
                    final allPhotos = getAllPhotoFromGroupImage(albumFolders);

                    await saveManyImages(context, allPhotos);
                  },
                  value: Menu.download,
                  child: ListTile(
                    leading: Icon(Icons.download_outlined),
                    title: Text('Download'),
                  ),
                ),
                PopupMenuItem<Menu>(
                  value: Menu.delete,
                  enabled: widget.albumId != null,
                  onTap: widget.albumId != null
                      ? () {
                          context
                              .read<DeleteAlbumCubit>()
                              .deleteAlbum(widget.albumId!);
                        }
                      : null,
                  child: const ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
          title: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${widget.totalItem} photos',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).colorScheme.outline),
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
    );
  }
}
