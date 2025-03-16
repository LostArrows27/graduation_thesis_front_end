import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/location_group.dart';
import 'package:graduation_thesis_front_end/features/location/presentation/widgets/location_map_view.dart';
import 'package:latlong2/latlong.dart';

class ExploreLocationPage extends StatefulWidget {
  final List<LocationGroup> locationGroups;

  const ExploreLocationPage({super.key, required this.locationGroups});

  @override
  State<ExploreLocationPage> createState() => _ExploreLocationPageState();
}

class _ExploreLocationPageState extends State<ExploreLocationPage> {
  @override
  Widget build(BuildContext context) {
    final representImage = widget.locationGroups.first.photos[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Location',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LocationMapView(
                            imageUrl: representImage.imageUrl!,
                            location: LatLng(representImage.latitude!,
                                representImage.longitude!)),
                      ),
                    ],
                  ),
                  Positioned.fill(
                      child: GestureDetector(
                    onTap: () {
                      final allPhotos = widget.locationGroups
                          .expand((element) => element.photos)
                          .toList();

                      final title = 'Photos Place';

                      context.push(Routes.imageLocationGroupMapPage, extra: {
                        'title': title,
                        'photos': allPhotos,
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 250,
                    ),
                  ))
                ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                itemBuilder: (context, index) {
                  var locationGroup = widget.locationGroups[index];
                  var representImage = locationGroup.photos[0].imageUrl!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.13),
                          onTap: () {
                            final title = locationGroup.name;
                            final photos = locationGroup.photos;

                            context
                                .push(Routes.imageLocationGroupMapPage, extra: {
                              'title': title,
                              'photos': photos,
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CachedImage(
                                        borderRadius: 20,
                                        imageUrl: representImage)),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(locationGroup.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8),
                                    Text('${locationGroup.photos.length} items',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: widget.locationGroups.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
