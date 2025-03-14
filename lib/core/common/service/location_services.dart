import 'package:geocoding/geocoding.dart';
import 'package:graduation_thesis_front_end/core/common/entities/location_with_address.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Convert coordinates to placemark
  static Future<Placemark?> getPlacemarkFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      print('Error retrieving placemark: $e');
      return null;
    }
  }

  /// Search for locations by query string
  static Future<List<LocationWithAddress>> searchLocations(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations.map((loc) => LocationWithAddress(loc)).toList();
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  /// Format address from placemark
  static String formatAddress(Placemark placemark) {
    List<String> addressParts = [];

    if (placemark.street?.isNotEmpty ?? false) {
      addressParts.add(placemark.street!);
    }
    if (placemark.locality?.isNotEmpty ?? false) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.subAdministrativeArea?.isNotEmpty ?? false) {
      addressParts.add(placemark.subAdministrativeArea!);
    }
    if (placemark.administrativeArea?.isNotEmpty ?? false) {
      addressParts.add(placemark.administrativeArea!);
    }
    if (placemark.country?.isNotEmpty ?? false) {
      addressParts.add(placemark.country!);
    }

    return addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Unknown location';
  }

  /// Convert LatLng to Location model
  static Location latLngToLocation(LatLng latLng) {
    return Location(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
    );
  }
}
