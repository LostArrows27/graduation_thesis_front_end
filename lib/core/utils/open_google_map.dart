import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMap(BuildContext context, LatLng location) async {
  final url =
      'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
  final uri = Uri.parse(Uri.encodeFull(url));

  launchUrl(uri).onError(
    (error, stackTrace) {
      showErrorSnackBar(context, 'Failed to open Google Map');
      return false;
    },
  );
}
