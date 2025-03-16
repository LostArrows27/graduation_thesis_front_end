import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album/album_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/cubit/choose_image_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/location/presentation/widgets/location_image_browser.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/browse_online_gallery_header.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:provider/provider.dart';

void openChooseLocationAlbumModal(BuildContext context) {
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
                      create: (_) => ChooseLocationImageModal(
                          providedImages: state.photos),
                      child: ChooseLocationImageBody(
                          modalHeightSize: modalHeightSize,
                          scrollController: scrollController),
                    );
                  },
                ),
              ),
            );
          });
    },
  );
}

class ChooseLocationImageBody extends StatelessWidget {
  const ChooseLocationImageBody(
      {super.key,
      required this.modalHeightSize,
      required this.scrollController});

  final double modalHeightSize;
  final ScrollController scrollController;

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
                                                  'Choose image to add location'),
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

                                              final chooseLocationImage = Provider
                                                  .of<ChooseLocationImageModal>(
                                                      context);

                                              if (chooseModeState ==
                                                  ChooseImageMode.album) {
                                                return BlocBuilder<PhotoBloc,
                                                        PhotoState>(
                                                    builder:
                                                        (context, photoState) {
                                                  return BlocBuilder<
                                                      AlbumListBloc,
                                                      AlbumListState>(
                                                    builder: (context, state) {
                                                      if (state is AlbumListLoading ||
                                                          state
                                                              is AlbumListInitial ||
                                                          photoState
                                                              is PhotoInitial ||
                                                          photoState
                                                              is PhotoFetchLoading) {
                                                        return Expanded(
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      }

                                                      if (state
                                                              is AlbumListError ||
                                                          photoState
                                                              is PhotoFetchFailure) {
                                                        return Expanded(
                                                            child: FailureWidget(
                                                                message:
                                                                    'Failed to load album list'));
                                                      }

                                                      final albumList = (state
                                                              as AlbumListLoaded)
                                                          .albums;

                                                      final recentlyAlbum = Album(
                                                          id:
                                                              'recently_album_id',
                                                          ownerId: (context
                                                                      .read<
                                                                          AppUserCubit>()
                                                                      .state
                                                                  as AppUserLoggedIn)
                                                              .user
                                                              .id,
                                                          createdAt:
                                                              DateTime.now(),
                                                          updatedAt:
                                                              DateTime.now(),
                                                          imageList: (photoState
                                                                  as PhotoFetchSuccess)
                                                              .photos,
                                                          imageIdList:
                                                              (photoState)
                                                                  .photos
                                                                  .map((e) =>
                                                                      e.id)
                                                                  .toList(),
                                                          name: 'Recently');

                                                      List<Album> newAlbumList =
                                                          [...albumList];

                                                      if (recentlyAlbum
                                                          .imageList
                                                          .isNotEmpty) {
                                                        newAlbumList.insert(
                                                            0, recentlyAlbum);
                                                      }

                                                      return Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child:
                                                              GridView.builder(
                                                                  itemCount:
                                                                      newAlbumList
                                                                          .length,
                                                                  controller:
                                                                      scrollController,
                                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          2,
                                                                      crossAxisSpacing:
                                                                          20,
                                                                      mainAxisSpacing:
                                                                          20,
                                                                      childAspectRatio:
                                                                          0.88),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final album =
                                                                        newAlbumList[
                                                                            index];

                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        chooseLocationImage
                                                                            .setProvidedImage(newAlbumList[index].imageList);
                                                                        context
                                                                            .read<ChooseImageModeCubit>()
                                                                            .changeViewMode(ChooseImageMode.all);
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 180,
                                                                              width: double.infinity,
                                                                              child: CachedImage(borderRadius: 20, imageUrl: album.imageList[0].imageUrl!)),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          Text(
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              album.name,
                                                                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline))
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                              }

                                              return Expanded(
                                                child: Column(
                                                  children: [
                                                    LocationImageBrowser(
                                                      scrollController:
                                                          scrollController,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8,
                                                                vertical: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            OutlinedButton.icon(
                                                                style: OutlinedButton
                                                                    .styleFrom(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .transparent),
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
                                                              child:
                                                                  FilledButton(
                                                                      style: FilledButton
                                                                          .styleFrom(
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .tertiaryContainer,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16)),
                                                                      ),
                                                                      onPressed: chooseLocationImage
                                                                              .selectedImages
                                                                              .isEmpty
                                                                          ? null
                                                                          : () {
                                                                              Navigator.of(context).pop();
                                                                              context.push(Routes.pickImageLocationPage, extra: {
                                                                                'photos': chooseLocationImage.selectedImages
                                                                              });
                                                                            },
                                                                      child:
                                                                          Text(
                                                                        chooseLocationImage.selectedImages.isEmpty
                                                                            ? 'Add'
                                                                            : 'Add (${chooseLocationImage.selectedImages.length})',
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
                      ],
                    ),
                  ],
                )
              ],
            ));
      },
    );
  }
}

class ChooseLocationImageModal extends ChangeNotifier {
  List<Photo> selectedImages = [];
  List<Photo> providedImages = [];

  ChooseLocationImageModal({required this.providedImages});

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
    providedImages = images;
    notifyListeners();
  }

  void setSelectedImage(List<Photo> images) {
    selectedImages = images;
    notifyListeners();
  }
}
