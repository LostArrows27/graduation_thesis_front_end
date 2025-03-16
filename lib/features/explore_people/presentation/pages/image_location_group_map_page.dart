import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/controller/map_controller.dart';
import 'package:graduation_thesis_front_end/core/common/entities/image.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_album_image.dart';
import 'package:graduation_thesis_front_end/features/photo/domain/entities/album_folder.dart';
import 'package:latlong2/latlong.dart';

class ImageLocationGroupMapPage extends StatefulWidget {
  final String title;
  final List<Photo> photos;

  const ImageLocationGroupMapPage(
      {super.key, required this.title, required this.photos});

  @override
  State<ImageLocationGroupMapPage> createState() =>
      _ImageLocationGroupMapPageState();
}

class _ImageLocationGroupMapPageState extends State<ImageLocationGroupMapPage>
    with TickerProviderStateMixin {
  late final MapControllerWrapper _mapController;
  List<AlbumFolder> imageDateGroup = [];
  int currentIndex = 0;
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _mapController = MapControllerWrapper(vsync: this);
    _alignPositionOnUpdate = AlignOnUpdate.never;
    _alignPositionStreamController = StreamController<double?>();
    setState(() {
      imageDateGroup = groupImagePhotoByDate(widget.photos);
    });
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();

    super.dispose();
  }

  void moveToNextImage() {
    int groupIndex = 0;
    int imageIndex = 0;
    bool found = false;

    for (int i = 0; i < imageDateGroup.length && !found; i++) {
      final photos = imageDateGroup[i].photos;
      final currentPhoto = widget.photos[currentIndex];

      for (int j = 0; j < photos.length; j++) {
        if (photos[j].id == currentPhoto.id) {
          groupIndex = i;
          imageIndex = j;
          found = true;
          break;
        }
      }
    }

    if (found) {
      if (imageIndex < imageDateGroup[groupIndex].photos.length - 1) {
        imageIndex++;
      } else {
        groupIndex = (groupIndex + 1) % imageDateGroup.length;
        imageIndex = 0;
      }

      final nextPhoto = imageDateGroup[groupIndex].photos[imageIndex];
      final nextIndex = widget.photos.indexWhere((p) => p.id == nextPhoto.id);

      setState(() {
        currentIndex = nextIndex;
        _alignPositionOnUpdate = AlignOnUpdate.never;
      });

      _mapController
          .animateToPosition(LatLng(nextPhoto.latitude!, nextPhoto.longitude!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  FlutterMap(
                      mapController: _mapController.mapController,
                      options: MapOptions(
                          onPositionChanged:
                              (MapCamera camera, bool hasGesture) {
                            if (hasGesture) {
                              setState(
                                () => _alignPositionOnUpdate =
                                    AlignOnUpdate.never,
                              );
                            }
                          },
                          initialZoom: 14,
                          initialCenter: LatLng(widget.photos[0].latitude!,
                              widget.photos[0].longitude!)),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        CurrentLocationLayer(
                          alignPositionStream:
                              _alignPositionStreamController.stream,
                          alignPositionOnUpdate: _alignPositionOnUpdate,
                        ),
                        MarkerLayer(
                            markers: widget.photos.map((photo) {
                          final point =
                              LatLng(photo.latitude!, photo.longitude!);

                          return Marker(
                            point: point,
                            width: 56,
                            height: 56,
                            child: GestureDetector(
                              onDoubleTap: () {
                                context.push(Routes.imageSliderPage, extra: {
                                  'url': photo.imageUrl,
                                  'images': widget.photos,
                                  'heroTag': ''
                                });
                              },
                              onTap: () {
                                _mapController.animateToPosition(point,
                                    zoom: 18);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: CachedImage(
                                    imageUrl: photo.imageUrl!,
                                    borderRadius: 28),
                              ),
                            ),
                          );
                        }).toList()),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FloatingActionButton(
                                heroTag: "nextLocation-image-location",
                                mini: true,
                                onPressed: () {
                                  moveToNextImage();
                                },
                                child: Icon(Icons.arrow_forward),
                              ),
                              SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: "currentLocation-image-location",
                                mini: true,
                                onPressed: () {
                                  setState(
                                    () => _alignPositionOnUpdate =
                                        AlignOnUpdate.always,
                                  );
                                  _alignPositionStreamController.add(18);
                                },
                                child: Icon(Icons.my_location),
                              ),
                              SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: "zoomIn-image-location",
                                mini: true,
                                onPressed: () {
                                  _mapController.zoomIn();
                                },
                                child: Icon(Icons.add),
                              ),
                              SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: "zoomOut-image-location",
                                mini: true,
                                onPressed: () {
                                  _mapController.zoomOut();
                                },
                                child: Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ],
              )),
          Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, albumFolderIndex) {
                          final albumFolder = imageDateGroup[albumFolderIndex];
                          final photoList = albumFolder.photos;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 8, 8),
                                  child: Text(
                                    albumFolder.title,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                StaggeredGrid.count(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  children: photoList.map((photo) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentIndex = widget.photos
                                                  .indexWhere((element) =>
                                                      element.id == photo.id);
                                            });
                                            _mapController.animateToPosition(
                                                LatLng(photo.latitude!,
                                                    photo.longitude!),
                                                zoom: 18);
                                          },
                                          child: CachedImage(
                                            imageUrl: photo.imageUrl!,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: imageDateGroup.length)
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
