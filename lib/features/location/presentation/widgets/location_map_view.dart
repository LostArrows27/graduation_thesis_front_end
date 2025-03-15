import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:latlong2/latlong.dart';

class LocationMapView extends StatefulWidget {
  final String imageUrl;
  final LatLng location;

  const LocationMapView(
      {super.key, required this.imageUrl, required this.location});

  @override
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlutterMap(
            options: MapOptions(
              initialZoom: 13,
              initialCenter: widget.location,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.location,
                    width: 56,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CachedImage(
                          imageUrl: widget.imageUrl, borderRadius: 28),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
