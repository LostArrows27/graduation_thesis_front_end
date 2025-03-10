import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album/album_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/cubit/choose_image_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/widgets/album_image_browser.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/browse_online_gallery_header.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:provider/provider.dart';

void openChooseImageAlbumModal(BuildContext context, String albumName) {
  const modalHeightSize = 0.78;
  const modalMaxHeightSize = 0.8;

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
          initialChildSize: modalHeightSize,
          minChildSize: modalHeightSize,
          maxChildSize: modalMaxHeightSize,
          expand: false,
          builder: (context, scrollController) {
            return BlocProvider(
              create: (context) => serviceLocator<AlbumBloc>(),
              child: BlocProvider(
                create: (context) => serviceLocator<ChooseImageModeCubit>(),
                child: BlocBuilder<PhotoBloc, PhotoState>(
                  builder: (context, state) {
                    if (state is! PhotoFetchSuccess) {
                      return Center(
                        child: Text('error happended'),
                      );
                    }

                    return ChangeNotifierProvider(
                      create: (_) =>
                          ChooseAlbumImageModel(providedImages: state.photos),
                      child: ChooseImageAlbumModalBody(
                          modalHeightSize: modalHeightSize,
                          scrollController: scrollController,
                          albumName: albumName),
                    );
                  },
                ),
              ),
            );
          });
    },
  );
}

class ChooseImageAlbumModalBody extends StatelessWidget {
  const ChooseImageAlbumModalBody(
      {super.key,
      required this.modalHeightSize,
      required this.albumName,
      required this.scrollController});

  final double modalHeightSize;
  final ScrollController scrollController;
  final String albumName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, state) {
        if (state is PhotoFetchLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (state is! PhotoFetchSuccess) {
          return Center(
            child: Text('Error happended'),
          );
        }

        return BlocConsumer<AlbumBloc, AlbumState>(
          listener: (context, albumState) {
            if (albumState is AlbumError) {
              return showErrorSnackBar(context, albumState.message);
            }

            if (albumState is AlbumSuccess) {
              final album = albumState.album;

              List<Photo> albumImage = [];

              for (var photo in state.photos) {
                if (album.imageIdList.contains(photo.id)) {
                  albumImage.add(photo);
                }
              }

              List<AlbumFolder> groupedImage =
                  groupImagePhotoByDate(albumImage);

              Navigator.of(context).pop();

              context.read<AlbumListBloc>().add(AddAlbumEvent(
                      album: album.copyWith(
                    imageList: albumImage,
                    name: albumName,
                  )));

              context.push(Routes.albumViewerPage, extra: {
                'title': albumName,
                'totalItem': albumImage.length,
                'albumFolders': groupedImage,
              });
            }
          },
          builder: (context, albumState) {
            return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height *
                                    modalHeightSize,
                                child: Stack(children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BrowseOnlineGalleryHeader(
                                                  title:
                                                      'Choose image for your album'),
                                              SizedBox(height: 20),
                                              BlocSelector<
                                                  ChooseImageModeCubit,
                                                  ChooseImageModeState,
                                                  ChooseImageMode?>(
                                                selector: (chooseModeState) {
                                                  if (chooseModeState
                                                      is ChooseImageModeChange) {
                                                    return chooseModeState.mode;
                                                  }
                                                  return null;
                                                },
                                                builder:
                                                    (context, chooseModeState) {
                                                  if (chooseModeState == null) {
                                                    return Center(
                                                      child: Text(
                                                          'Something wrong happened !'),
                                                    );
                                                  }

                                                  if (chooseModeState ==
                                                      ChooseImageMode.album) {
                                                    return Center(
                                                        child:
                                                            Text('album mode'));
                                                  }

                                                  final chooseAlbumImageModel =
                                                      Provider.of<
                                                              ChooseAlbumImageModel>(
                                                          context);

                                                  return Expanded(
                                                    child: Column(
                                                      children: [
                                                        AlbumImageBrowser(
                                                          scrollController:
                                                              scrollController,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        20),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                OutlinedButton
                                                                    .icon(
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          side:
                                                                              BorderSide(color: Colors.transparent),
                                                                        ),
                                                                        icon: Icon(Icons
                                                                            .image),
                                                                        onPressed:
                                                                            () {},
                                                                        label: Text(
                                                                            'View selected')),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child: FilledButton(
                                                                      style: FilledButton.styleFrom(
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .tertiaryContainer,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16)),
                                                                      ),
                                                                      onPressed: chooseAlbumImageModel.selectedImages.isEmpty
                                                                          ? null
                                                                          : () {
                                                                              context.read<AlbumBloc>().add(CreateAlbumEvent(name: albumName, imageId: chooseAlbumImageModel.selectedImages.map((e) => e.id).toList()));
                                                                            },
                                                                      child: Text(
                                                                        chooseAlbumImageModel.selectedImages.isEmpty
                                                                            ? 'Add'
                                                                            : 'Add (${chooseAlbumImageModel.selectedImages.length})',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.onTertiaryContainer),
                                                                      )),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ])),
                            // NOTE: display based on loading status
                            albumState is AlbumLoading
                                ? Positioned.fill(
                                    child: Container(
                                    color: Colors.black54,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryFixedDim,
                                      ),
                                    ),
                                  ))
                                : Container()
                          ],
                        ),
                      ],
                    )
                  ],
                ));
          },
        );
      },
    );
  }
}

class ChooseAlbumImageModel extends ChangeNotifier {
  List<Photo> selectedImages = [];
  List<Photo> providedImages = [];

  ChooseAlbumImageModel({required this.providedImages});

  List<Photo> get getSelectImage => selectedImages;
  List<Photo> get getProviderImages => providedImages;

  void addImage(Photo photo) {
    selectedImages.add(photo);
    notifyListeners();
  }

  void removeImage(String imageId) {
    selectedImages.removeWhere((image) => image.id == imageId);
    notifyListeners();
  }

  void setProvidedImage(List<Photo> images) {
    providedImages.addAll(images);
    notifyListeners();
  }

  void setSelectedImage(List<Photo> images) {
    selectedImages.addAll(images);
    notifyListeners();
  }
}
