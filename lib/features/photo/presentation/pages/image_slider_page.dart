import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_widget.dart';
import 'package:graduation_thesis_front_end/core/theme/app_theme.dart';
import 'package:graduation_thesis_front_end/core/utils/dowload_image.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';
import 'package:graduation_thesis_front_end/core/utils/share_image.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/features/album/domain/entities/album.dart';
import 'package:graduation_thesis_front_end/features/album/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/face.dart';
import 'package:graduation_thesis_front_end/features/explore_people/domain/entities/person_group.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/bloc/person_group/person_group_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/edit_caption/edit_caption_bloc.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/edit_caption_modal.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/show_image_information_bottom_modal.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/widget/text_icon.dart';

class ImageSliderPage extends StatefulWidget {
  const ImageSliderPage(
      {super.key,
      required this.url,
      required this.images,
      required this.heroTag});
  final String url;
  final List<Photo> images;
  final String heroTag;
  @override
  State<ImageSliderPage> createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  List<Photo> images = [];

  final List<int> _cachedIndexes = <int>[];
  bool _isUIVisible = true;
  bool _isSliding = false;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int index =
        images.indexWhere((element) => element.imageUrl == widget.url);
    _preloadImage(index - 1);
    _preloadImage(index + 1);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.images.indexWhere((element) => element.imageUrl == widget.url);

    setState(() {
      images = widget.images;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _preloadImage(int index) {
    if (_cachedIndexes.contains(index)) {
      return;
    }
    if (0 <= index && index < images.length) {
      final String url = images[index].imageUrl!;
      if (url.startsWith('https:')) {
        precacheImage(ExtendedNetworkImageProvider(url, cache: true), context);
      }

      _cachedIndexes.add(index);
    }
  }

  void _toggleUI() {
    setState(() {
      _isUIVisible = !_isUIVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: BlocListener<EditCaptionBloc, EditCaptionState>(
        listener: (context, state) {
          if (state is EditCaptionFailure) {
            return showErrorSnackBar(context, state.message);
          }

          if (state is EditCaptionSuccess) {
            final caption = state.caption;
            final imageId = state.imageId;

            final index = images.indexWhere((element) => element.id == imageId);

            if (index != -1) {
              setState(() {
                images[index] = images[index].copyWith(caption: caption);
              });
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: (!_isSliding && _isUIVisible)
              ? AppBar(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    iconSize: 24,
                    onPressed: () {
                      setState(() {
                        _isUIVisible = false;
                      });
                      slidePagekey.currentState?.popPage();
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      iconSize: 24,
                      onPressed: () {
                        final photo = images[_currentIndex];
                        final albumState = context.read<AlbumListBloc>().state;

                        final personGroupState =
                            context.read<PersonGroupBloc>().state;

                        if (albumState is AlbumListLoaded &&
                            (personGroupState is PersonGroupSuccess ||
                                personGroupState is ChangeGroupNameSuccess)) {
                          List<Album> albums = [];

                          for (var album in albumState.albums) {
                            if (album.imageIdList.contains(photo.id)) {
                              albums.add(album);
                            }
                          }

                          List<Face> faces = [];
                          List<PersonGroup> allPersonGroup = [];

                          if (personGroupState is PersonGroupSuccess) {
                            allPersonGroup = personGroupState.personGroups;
                          } else if (personGroupState
                              is ChangeGroupNameSuccess) {
                            allPersonGroup = personGroupState.personGroups;
                          }

                          for (var group in allPersonGroup) {
                            for (var face in group.faces) {
                              if (face.imageId == photo.id) {
                                faces.add(face.copyWith(name: group.name));
                              }
                            }
                          }

                          showImageInformationBottomModal(
                              context, photo, albums, faces);
                        }
                      },
                    ),
                  ],
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDate(images[_currentIndex].createdAt!),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        formatTime(images[_currentIndex].createdAt!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ))
              : AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                ),
          body: Material(
            color: Colors.transparent,
            child: ExtendedImageSlidePage(
              key: slidePagekey,
              slideAxis: SlideAxis.both,
              slideType: SlideType.wholePage,
              onSlidingPage: (state) {
                if (mounted) {
                  setState(() {
                    _isSliding = state.isSliding;
                  });
                }
              },
              slidePageBackgroundHandler: (offset, size) {
                double scale = offset.distance / (size.width / 2);
                scale = scale.clamp(0.0, 1.0);
                return Colors.black.withOpacity(1.0 - scale);
              },
              child: GestureDetector(
                onTap: _toggleUI,
                child: ExtendedImageGesturePageView.builder(
                  controller: ExtendedPageController(
                    initialPage: images.indexWhere(
                        (element) => element.imageUrl == widget.url),
                    pageSpacing: 50,
                    shouldIgnorePointerWhenScrolling: false,
                  ),
                  itemCount: images.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentIndex = page;
                    });
                    _preloadImage(page - 1);
                    _preloadImage(page + 1);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final String url = images[index].imageUrl!;

                    // NOTE: in case not use image asset
                    return url == 'This is an video'
                        ? ExtendedImageSlidePageHandler(
                            child: Material(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.yellow,
                                child: const Text('This is an video'),
                              ),
                            ),

                            ///make hero better when slide out
                            heroBuilderForSlidingPage: (Widget result) {
                              return Hero(
                                tag: url + widget.heroTag,
                                child: result,
                                flightShuttleBuilder:
                                    (BuildContext flightContext,
                                        Animation<double> animation,
                                        HeroFlightDirection flightDirection,
                                        BuildContext fromHeroContext,
                                        BuildContext toHeroContext) {
                                  final Hero hero = (flightDirection ==
                                          HeroFlightDirection.pop
                                      ? fromHeroContext.widget
                                      : toHeroContext.widget) as Hero;

                                  return hero.child;
                                },
                              );
                            },
                          )
                        : HeroWidget(
                            tag: url + widget.heroTag,
                            slideType: SlideType.wholePage,
                            slidePagekey: slidePagekey,
                            child: ExtendedImage.network(
                              url,
                              enableSlideOutPage: true,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.gesture,
                              initGestureConfigHandler:
                                  (ExtendedImageState state) {
                                return GestureConfig(
                                  //you must set inPageView true if you want to use ExtendedImageGesturePageView
                                  inPageView: true,
                                  initialScale: 1.0,
                                  maxScale: 5.0,
                                  animationMaxScale: 6.0,
                                  initialAlignment: InitialAlignment.center,
                                );
                              },
                            ),
                          );
                  },
                ),
              ),
            ),
          ),
          bottomNavigationBar: (!_isSliding && _isUIVisible)
              ? Container(
                  color: Colors.black.withOpacity(0.4),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (images[_currentIndex].caption != null)
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: Text(
                              images[_currentIndex].caption!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                images[_currentIndex]
                                        .labels
                                        .labels
                                        .locationLabels
                                        .isNotEmpty
                                    ? Wrap(
                                        spacing:
                                            15, // gap between adjacent chips
                                        runSpacing: 10, // gap between Lines,
                                        children: [
                                          ...images[_currentIndex]
                                              .labels
                                              .labels
                                              .locationLabels
                                              .map(
                                                (e) => Chip(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0.0,
                                                          vertical: -4),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  label: Text(
                                                    e.label,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                          ...images[_currentIndex]
                                              .labels
                                              .labels
                                              .eventLabels
                                              .map(
                                                (e) => Chip(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0.0,
                                                          vertical: -4),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  label: Text(
                                                    e.label,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                          ...images[_currentIndex]
                                              .labels
                                              .labels
                                              .actionLabels
                                              .map(
                                                (e) => Chip(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 0.0,
                                                          vertical: -4),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  label: Text(
                                                    e.label,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Divider(
                                color: Theme.of(context).colorScheme.outline,
                                thickness: 0.5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  textIcon(Icons.share, 'Share', () {
                                    shareImages(images[_currentIndex]);
                                  }),
                                  textIcon(Icons.favorite_border, 'Favorite',
                                      () {
                                    // TODO: add to favorite
                                  }),
                                  textIcon(Icons.download, 'Save', () {
                                    saveImage(context, images[_currentIndex]);
                                  }),
                                  textIcon(Icons.edit, 'Edit', () {
                                    openEditCaptionModel(
                                        context,
                                        images[_currentIndex].caption,
                                        images[_currentIndex].id);
                                  }),
                                  textIcon(Icons.delete_outline, 'Delete', () {
                                    // TODO: show delete modal
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 150,
                  color: Colors.transparent,
                ),
        ),
      ),
    );
  }
}
