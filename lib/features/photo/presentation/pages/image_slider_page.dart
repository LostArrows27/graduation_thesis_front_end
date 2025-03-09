import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/hero_widget.dart';
import 'package:graduation_thesis_front_end/core/theme/app_theme.dart';
import 'package:graduation_thesis_front_end/core/utils/format_date.dart';

class ImageSliderPage extends StatefulWidget {
  const ImageSliderPage({super.key, required this.url, required this.images});
  final String url;
  final List<Photo> images;
  @override
  State<ImageSliderPage> createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  final List<int> _cachedIndexes = <int>[];
  bool _isUIVisible = true;
  bool _isSliding = false;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int index =
        widget.images.indexWhere((element) => element.imageUrl == widget.url);
    _preloadImage(index - 1);
    _preloadImage(index + 1);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.images.indexWhere((element) => element.imageUrl == widget.url);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _preloadImage(int index) {
    if (_cachedIndexes.contains(index)) {
      return;
    }
    if (0 <= index && index < widget.images.length) {
      final String url = widget.images[index].imageUrl!;
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

  Widget _textIcon(IconData icon, String text, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  SizedBox(height: 4),
                  Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
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
                      // TODO: display information
                      // 1. note 
                      // 2. add location
                      // 3. add event
                    },
                  ),
                ],
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(widget.images[_currentIndex].createdAt!),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      formatTime(widget.images[_currentIndex].createdAt!),
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
                  initialPage: widget.images
                      .indexWhere((element) => element.imageUrl == widget.url),
                  pageSpacing: 50,
                  shouldIgnorePointerWhenScrolling: false,
                ),
                itemCount: widget.images.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentIndex = page;
                  });
                  _preloadImage(page - 1);
                  _preloadImage(page + 1);
                },
                itemBuilder: (BuildContext context, int index) {
                  final String url = widget.images[index].imageUrl!;

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
                              tag: url,
                              child: result,
                              flightShuttleBuilder: (BuildContext flightContext,
                                  Animation<double> animation,
                                  HeroFlightDirection flightDirection,
                                  BuildContext fromHeroContext,
                                  BuildContext toHeroContext) {
                                final Hero hero =
                                    (flightDirection == HeroFlightDirection.pop
                                        ? fromHeroContext.widget
                                        : toHeroContext.widget) as Hero;

                                return hero.child;
                              },
                            );
                          },
                        )
                      : HeroWidget(
                          tag: url,
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
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.images[_currentIndex].labels.labels
                                      .locationLabels.isNotEmpty
                                  ? Wrap(
                                      spacing: 15, // gap between adjacent chips
                                      runSpacing: 10, // gap between Lines,
                                      children: [
                                        ...widget.images[_currentIndex].labels
                                            .labels.locationLabels
                                            .map(
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
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        ...widget.images[_currentIndex].labels
                                            .labels.eventLabels
                                            .map(
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
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        ...widget.images[_currentIndex].labels
                                            .labels.actionLabels
                                            .map(
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
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _textIcon(Icons.share, 'Share', () {
                                  // TODO: share image
                                }),
                                _textIcon(Icons.favorite_border, 'Favorite',
                                    () {
                                  // TODO: add to favorite
                                }),
                                _textIcon(Icons.download, 'Save', () {
                                  // TODO: save local
                                }),
                                _textIcon(Icons.edit, 'Edit', () {
                                  // TODO: show edit modal
                                }),
                                _textIcon(Icons.delete_outline, 'Delete', () {
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
    );
  }
}
