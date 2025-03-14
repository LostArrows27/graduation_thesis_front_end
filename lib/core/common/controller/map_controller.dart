import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class MapControllerWrapper {
  final AnimatedMapController controller;

  MapControllerWrapper({required TickerProvider vsync})
      : controller = AnimatedMapController(
          vsync: vsync,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          cancelPreviousAnimations: true,
        );

  void animateToPosition(LatLng position, {double zoom = 16}) {
    controller.animateTo(
      dest: position,
      zoom: zoom,
    );
  }

  void zoomIn() => controller.animatedZoomIn();

  void zoomOut() => controller.animatedZoomOut();

  MapController get mapController => controller.mapController;
}
