import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/service/location_services.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/dowload_image.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date_to_full_time.dart';
import 'package:graduation_thesis_front_end/core/utils/get_color_scheme.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/core/utils/open_google_map.dart';
import 'package:graduation_thesis_front_end/core/utils/share_image.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/widgets/cropped_avatar.dart';
import 'package:graduation_thesis_front_end/features/location/presentation/widgets/location_map_view.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/delete_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/cubit/favorite_image_cubit.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/edit_caption_modal.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/image_information.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/text_icon.dart';
import 'package:latlong2/latlong.dart';

void showImageInformationBottomModal(
    BuildContext context, Photo photo, List<Album> albums, List<Face> faces) {
  IconData getHeartIcon(FavoriteImageState favoriteState) {
    bool isFavorite = false;

    // Check if we have a recent state update for this specific photo
    if (favoriteState is FavoriteImageSuccess &&
        favoriteState.imageId == photo.id) {
      isFavorite = favoriteState.isFavorite;
    } else {
      isFavorite = photo.isFavorite;
    }

    return isFavorite ? Icons.favorite_sharp : Icons.favorite_border;
  }

  bool getCurrentFavoriteState(FavoriteImageState favoriteState) {
    bool isFavorite = false;

    if (favoriteState is FavoriteImageSuccess &&
        favoriteState.imageId == photo.id) {
      isFavorite = favoriteState.isFavorite;
    } else {
      isFavorite = photo.isFavorite;
    }

    return isFavorite;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return BlocBuilder<FavoriteImageCubit, FavoriteImageState>(
        builder: (context, favoriteState) {
          return BlocBuilder<EditCaptionBloc, EditCaptionState>(
            builder: (context, state) {
              return DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.25,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        SizedBox(height: 4),
                        Center(
                          child: Container(
                            width: 30,
                            height: 3,
                            color: getColorScheme(context).outline,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textIcon(Icons.share, 'Share', () {
                              shareImages(photo);
                            }, true),
                            textIcon(getHeartIcon(favoriteState), 'Favorite',
                                () {
                              context.read<FavoriteImageCubit>().favoriteImage(
                                  photo.id,
                                  !getCurrentFavoriteState(favoriteState));
                            }, true, getCurrentFavoriteState(favoriteState)),
                            textIcon(Icons.download, 'Save', () async {
                              await saveImage(context, photo);
                            }, true),
                            textIcon(Icons.edit, 'Edit', () {
                              openEditCaptionModel(
                                  context, photo.caption, photo.id);
                            }, true),
                            textIcon(Icons.delete_outline, 'Delete', () {
                              context.read<DeleteImageCubit>().deleteImage(
                                  photo.imageBucketId, photo.imageName);
                            }, true),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color:
                              getColorScheme(context).surfaceContainerHighest,
                          thickness: 1.5,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              formatDateToFullTime(photo.createdAt!),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                            IconButton(
                                onPressed: () {
                                  openEditCaptionModel(
                                      context, photo.caption, photo.id);
                                },
                                iconSize: 20,
                                icon: Icon(Icons.edit))
                          ],
                        ),
                        SizedBox(height: 10),
                        state is EditCaptionSuccess && state.imageId == photo.id
                            ? Text(
                                state.caption,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              )
                            : photo.caption != null && photo.caption!.isNotEmpty
                                ? Text(
                                    photo.caption!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      openEditCaptionModel(
                                          context, photo.caption, photo.id);
                                    },
                                    child: Text(
                                      "Add a caption...",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: getColorScheme(context).outline,
                                      ),
                                    ),
                                  ),
                        albums.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30),
                                  Text(
                                    'Albums',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        final album = albums[index];
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    Routes.albumViewerPage,
                                                    extra: {
                                                      'title':
                                                          albums[index].name,
                                                      'totalItem': albums[index]
                                                          .imageList
                                                          .length,
                                                      'albumFolders':
                                                          groupImagePhotoByDate(
                                                              albums[index]
                                                                  .imageList),
                                                      'heroTag': '',
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 90,
                                                    height: 90,
                                                    child: CachedImage(
                                                        borderRadius: 10,
                                                        imageUrl: album
                                                            .imageList[0]
                                                            .imageUrl!),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          album.name,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          '${album.imageList.length} items',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                getColorScheme(
                                                                        context)
                                                                    .outline,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        );
                                      },
                                      itemCount: albums.length)
                                ],
                              )
                            : Container(),
                        photo.latitude != null && photo.longitude != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            await openGoogleMap(
                                                context,
                                                LatLng(photo.latitude!,
                                                    photo.longitude!));
                                          },
                                          child: Text('Open in Maps'))
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  LocationMapView(
                                      imageUrl: photo.imageUrl!,
                                      location: LatLng(
                                          photo.latitude!, photo.longitude!)),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocationService
                                                  .formatShortAddress(
                                                      photo.locationMetaData!),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${photo.latitude!.toStringAsFixed(4)}, ${photo.longitude!.toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: getColorScheme(context)
                                                    .outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      IconButton(
                                          onPressed: () {
                                            context.push(
                                                Routes.pickImageLocationPage,
                                                extra: {
                                                  'photos': [photo],
                                                  'initialPosition': LatLng(
                                                      photo.latitude!,
                                                      photo.longitude!),
                                                  'initialPlacemark':
                                                      photo.locationMetaData!
                                                });
                                          },
                                          iconSize: 20,
                                          icon: Icon(Icons.edit)),
                                    ],
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add a location...',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              getColorScheme(context).outline,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            context.push(
                                                Routes.pickImageLocationPage,
                                                extra: {
                                                  'photos': [photo],
                                                });
                                          },
                                          iconSize: 20,
                                          icon: Icon(Icons.edit)),
                                    ],
                                  )
                                ],
                              ),
                        faces.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'People',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final face = faces[index];
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 90,
                                                        height: 90,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: buildFaceImage(
                                                              face),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        face.name ?? 'Unknown',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 16),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount: faces.length),
                                  )
                                ],
                              )
                            : Container(),
                        photo.labels.labels.locationLabels.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'Smart Tags',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8, // gap between adjacent chips
                                    runSpacing: 8, // gap between Lines,
                                    children: [
                                      ...photo.labels.labels.locationLabels.map(
                                        (e) => Chip(
                                          visualDensity: const VisualDensity(
                                              horizontal: 0.0, vertical: -4),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      ...photo.labels.labels.eventLabels.map(
                                        (e) => Chip(
                                          visualDensity: const VisualDensity(
                                              horizontal: 0.0, vertical: -4),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      ...photo.labels.labels.actionLabels.map(
                                        (e) => Chip(
                                          visualDensity: const VisualDensity(
                                              horizontal: 0.0, vertical: -4),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          label: Text(
                                            e.label,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(height: 20),
                        Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        ImageInformation(
                            imageUrl: photo.imageUrl!, name: photo.imageName)
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
