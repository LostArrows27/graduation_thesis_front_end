import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/utils/group_image_by_location.dart';
import 'package:graduation_thesis_front_end/features/explore_people/presentation/pages/location_group.dart';
import 'package:graduation_thesis_front_end/features/location/presentation/widgets/location_map_view.dart';
import 'package:graduation_thesis_front_end/features/photo/presentation/bloc/photo/photo_bloc.dart';
import 'package:latlong2/latlong.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  List<LocationGroup> locationGroup = [];

  @override
  void initState() {
    super.initState();

    final photoState = context.read<PhotoBloc>().state;

    if (photoState is PhotoFetchSuccess) {
      setState(() {
        locationGroup = groupImageByLocation(photoState.photos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhotoBloc, PhotoState>(
      listener: (context, state) {
        if (state is PhotoFetchSuccess) {
          setState(() {
            locationGroup = groupImageByLocation(state.photos);
          });
        }
      },
      builder: (context, state) {
        if (state is PhotoFetchLoading || state is PhotoInitial) {
          return Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 172,
                  width: 172,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Place',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            )
          ]);
        }

        if (locationGroup.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 172,
                    width: 172,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LocationMapView(
                        location: LatLng(21.037547, 105.784585)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Place',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '${locationGroup.length}',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          );
        }

        locationGroup
            .sort((a, b) => b.photos.length.compareTo(a.photos.length));

        final representImage = locationGroup.first.photos[0];

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 172,
                  width: 172,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LocationMapView(
                      imageUrl: representImage.imageUrl!,
                      location: LatLng(
                          representImage.latitude!, representImage.longitude!)),
                ),
                Positioned.fill(
                    child: GestureDetector(
                  onTap: () {
                    context.push(Routes.exploreLocationPage,
                        extra: locationGroup);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 172,
                    height: 172,
                  ),
                ))
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Place',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 3),
            Text(
              '${locationGroup.length}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        );
      },
    );
  }
}
