import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/enum/app_enum.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/failure.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/cubit/choose_image_mode_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:graduation_thesis_front_end/features/video_render/domain/entities/selected_image.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/pages/video_image_picker_page.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/browse_online_gallery_header.dart';
import 'package:graduation_thesis_front_end/features/video_render/presentation/widgets/online_image_browse.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';
import 'package:provider/provider.dart';

void showBrowseOnlineGalleryModal(
  BuildContext context,
) {
  const modalHeightSize = 0.78;
  const modalMaxHeightSize = 0.8;

  final imageProvider = Provider.of<ImageProviderModel>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    builder: (context) {
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

          return ChangeNotifierProvider(
            create: (_) => ProviderImageModel(providedImages: state.photos),
            child: BlocProvider(
              create: (context) => serviceLocator<ChooseImageModeCubit>(),
              child: BrowseOnlineGalleryBody(
                  modalHeightSize: modalHeightSize,
                  modalMaxHeightSize: modalMaxHeightSize,
                  imageProvider: imageProvider),
            ),
          );
        },
      );
    },
  );
}

class BrowseOnlineGalleryBody extends StatelessWidget {
  const BrowseOnlineGalleryBody({
    super.key,
    required this.modalHeightSize,
    required this.modalMaxHeightSize,
    required this.imageProvider,
  });

  final double modalHeightSize;
  final double modalMaxHeightSize;
  final ImageProviderModel imageProvider;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: modalHeightSize,
        minChildSize: modalHeightSize,
        maxChildSize: modalMaxHeightSize,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height * modalHeightSize,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BrowseOnlineGalleryHeader(),
                                SizedBox(height: 20),
                                BlocSelector<ChooseImageModeCubit,
                                    ChooseImageModeState, ChooseImageMode?>(
                                  selector: (chooseModeState) {
                                    if (chooseModeState
                                        is ChooseImageModeChange) {
                                      return chooseModeState.mode;
                                    }
                                    return null;
                                  },
                                  builder: (context, chooseModeState) {
                                    if (chooseModeState == null) {
                                      return Center(
                                        child:
                                            Text('Something wrong happened !'),
                                      );
                                    }

                                    if (chooseModeState ==
                                        ChooseImageMode.album) {
                                      return BlocBuilder<PhotoBloc, PhotoState>(
                                          builder: (context, photoState) {
                                        return BlocBuilder<AlbumListBloc,
                                                AlbumListState>(
                                            builder: (context, state) {
                                          if (state is AlbumListLoading ||
                                              state is AlbumListInitial ||
                                              photoState is PhotoInitial ||
                                              photoState is PhotoFetchLoading) {
                                            return Expanded(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }

                                          if (state is AlbumListError ||
                                              photoState is PhotoFetchFailure) {
                                            return Expanded(
                                                child: FailureWidget(
                                                    message:
                                                        'Failed to load album list'));
                                          }

                                          final providerImageModel =
                                              Provider.of<ProviderImageModel>(
                                                  context,
                                                  listen: false);

                                          final albumList =
                                              (state as AlbumListLoaded).albums;

                                          final recentlyAlbum = Album(
                                              id: 'recently_album_id',
                                              ownerId: (context
                                                      .read<AppUserCubit>()
                                                      .state as AppUserLoggedIn)
                                                  .user
                                                  .id,
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                              imageList: (photoState
                                                      as PhotoFetchSuccess)
                                                  .photos,
                                              imageIdList: (photoState)
                                                  .photos
                                                  .map((e) => e.id)
                                                  .toList(),
                                              name: 'Recently');

                                          List<Album> newAlbumList = [
                                            ...albumList
                                          ];

                                          if (recentlyAlbum
                                              .imageList.isNotEmpty) {
                                            newAlbumList.insert(
                                                0, recentlyAlbum);
                                          }

                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GridView.builder(
                                                  itemCount:
                                                      newAlbumList.length,
                                                  controller: scrollController,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20,
                                                          childAspectRatio:
                                                              0.88),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final album =
                                                        newAlbumList[index];

                                                    return GestureDetector(
                                                      onTap: () {
                                                        providerImageModel
                                                            .setProviderImages(
                                                                newAlbumList[
                                                                        index]
                                                                    .imageList);
                                                        context
                                                            .read<
                                                                ChooseImageModeCubit>()
                                                            .changeViewMode(
                                                                ChooseImageMode
                                                                    .all);
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              height: 180,
                                                              width: double
                                                                  .infinity,
                                                              child: CachedImage(
                                                                  borderRadius:
                                                                      20,
                                                                  imageUrl: album
                                                                      .imageList[
                                                                          0]
                                                                      .imageUrl!)),
                                                          SizedBox(height: 10),
                                                          Text(
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              album.name,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .outline))
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                        });
                                      });
                                    }

                                    return OnlineImageBrowse(
                                      imageProvider: imageProvider,
                                      scrollController: scrollController,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );
        });
  }
}

class ProviderImageModel extends ChangeNotifier {
  List<Photo> providedImages = [];
  List<String> selectedImages = [];

  ProviderImageModel({required this.providedImages});

  List<Photo> get getProviderImages => providedImages;
  List<String> get getSelectedImages => selectedImages;

  void setProviderImages(List<Photo> photos) {
    providedImages = photos;
    notifyListeners();
  }

  void addImage(SelectedImage image) {
    selectedImages.add(image.filePath);
    notifyListeners();
  }

  void removeImage(String imageUrl) {
    selectedImages.remove(imageUrl);
    notifyListeners();
  }

  void addAllImage(List<String> allPath) {
    selectedImages.addAll(allPath);
  }

  void clearSelectedImages() {
    selectedImages.clear();
    notifyListeners();
  }
}
