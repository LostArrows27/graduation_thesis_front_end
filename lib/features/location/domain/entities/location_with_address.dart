import 'package:geocoding/geocoding.dart';

class LocationWithAddress {
  final Location location;
  String? address;

  LocationWithAddress(this.location, [this.address]);
}
