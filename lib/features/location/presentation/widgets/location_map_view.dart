import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/cached_image.dart';
import 'package:latlong2/latlong.dart';

class LocationMapView extends StatefulWidget {
  final String? imageUrl;
  final LatLng? location;
  final bool interactive;

  const LocationMapView(
      {super.key, this.imageUrl, this.location, this.interactive = true});

  @override
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _alignPositionOnUpdate = AlignOnUpdate.never;
    _alignPositionStreamController = StreamController<double?>();
    if (widget.location == null || widget.imageUrl == null) {
      _alignPositionOnUpdate = AlignOnUpdate.always;
    }
  }

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
                initialCenter: widget.location ?? LatLng(21.037547, 105.784585),
                onTap: widget.interactive ? null : (_, __) {}),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (widget.imageUrl == null && widget.location == null)
                CurrentLocationLayer(
                  alignPositionStream: _alignPositionStreamController.stream,
                  alignPositionOnUpdate: _alignPositionOnUpdate,
                ),
              if (widget.imageUrl != null && widget.location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.location!,
                      width: 56,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: CachedImage(
                            imageUrl: widget.imageUrl!, borderRadius: 28),
                      ),
                    ),
                  ],
                ),
            ]),
      ),
    );
  }
}
