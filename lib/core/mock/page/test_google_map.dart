import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:graduation_thesis_front_end/core/common/controller/map_controller.dart';
import 'package:graduation_thesis_front_end/features/location/domain/entities/location_with_address.dart';
import 'package:graduation_thesis_front_end/core/common/service/location_services.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapPlacemarkScreen extends StatefulWidget {
  const MapPlacemarkScreen({super.key});

  @override
  State<MapPlacemarkScreen> createState() => _MapPlacemarkScreenState();
}

class _MapPlacemarkScreenState extends State<MapPlacemarkScreen>
    with TickerProviderStateMixin {
  LatLng? _selectedPosition;
  Placemark? _placemark;
  bool _isLoading = false;
  late final MapControllerWrapper _mapController;
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<LocationWithAddress> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapControllerWrapper(vsync: this);
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Picker'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController.mapController,
                  options: MapOptions(
                    initialCenter: LatLng(21.037547, 105.784585),
                    initialZoom: 13,
                    onTap: (tapPosition, point) => _handleMapTap(point),
                    onPositionChanged: (MapCamera camera, bool hasGesture) {
                      if (hasGesture) {
                        setState(
                          () => _alignPositionOnUpdate = AlignOnUpdate.never,
                        );
                      }
                    },
                  ),
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
                    if (_selectedPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedPosition!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Search bar at the top
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search for a location',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchResults.clear();
                                        _showSearchResults = false;
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          onChanged: _onSearchTextChanged,
                          onTap: () {
                            setState(() {
                              _showSearchResults = _searchResults.isNotEmpty;
                            });
                          },
                        ),
                      ),

                      // Search results container
                      if (_showSearchResults)
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          constraints: BoxConstraints(
                            maxHeight: 250, // Limit height of results
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: _isSearching
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : _searchResults.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('No results found'),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: _searchResults.length,
                                      itemBuilder: (context, index) {
                                        final item = _searchResults[index];
                                        final location = item.location;
                                        final address = item.address;

                                        return ListTile(
                                          title: address != null
                                              ? Text(
                                                  address,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  'Fetching address...',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                          subtitle: Text(
                                            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          onTap: () =>
                                              _selectSearchResult(index),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                        );
                                      },
                                    ),
                        ),
                    ],
                  ),
                ),

                // Loading indicator overlay
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Location information panel
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _selectedPosition == null
                  ? const Center(
                      child: Text(
                        'Tap on the map\nto select a location',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : _buildLocationInfoPanel(),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'my_location',
            mini: true,
            onPressed: () {
              setState(
                () => _alignPositionOnUpdate = AlignOnUpdate.always,
              );
              _alignPositionStreamController.add(18);
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'zoom_in',
            onPressed: () {
              _mapController.zoomIn();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'zoom_out',
            onPressed: () {
              _mapController.zoomOut();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.length >= 3) {
        setState(() {
          _isSearching = true;
          _showSearchResults = true;
        });

        try {
          final results = await LocationService.searchLocations(query);

          setState(() {
            _searchResults = results;
            _isSearching = false;
          });

          _fetchAddressesForSearchResults(results);
        } catch (e) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });

          // Only show error if search box is still focused
          if (_searchFocusNode.hasFocus) {
            print('Error searching location: $e');
          }
        }
      }
    });
  }

  Future<void> _fetchAddressesForSearchResults(
      List<LocationWithAddress> locations) async {
    for (int i = 0; i < locations.length; i++) {
      try {
        final loc = locations[i].location;

        // Using LocationService to get placemark
        final placemark = await LocationService.getPlacemarkFromCoordinates(
            loc.latitude, loc.longitude);

        if (placemark != null && mounted) {
          final address = LocationService.formatAddress(placemark);
          setState(() {
            locations[i].address = address;
          });
        }
      } catch (e) {
        continue;
      }
    }
  }

  void _selectSearchResult(int index) async {
    if (index >= 0 && index < _searchResults.length) {
      final locationWithAddress = _searchResults[index];
      final location = locationWithAddress.location;
      final latLng = LatLng(location.latitude, location.longitude);

      setState(() {
        _showSearchResults = false;
        _searchFocusNode.unfocus();
        _alignPositionOnUpdate = AlignOnUpdate.never;
      });

      _mapController.animateToPosition(
        latLng,
        zoom: 16,
      );

      await _handleMapTap(latLng);
    }
  }

  Future<void> _handleMapTap(LatLng point) async {
    setState(() {
      _selectedPosition = point;
      _isLoading = true;
      _alignPositionOnUpdate = AlignOnUpdate.never;
    });

    try {
      final placemarks = await LocationService.getPlacemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      setState(() {
        _placemark = placemarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error retrieving location data: $e');
    }
  }

  Widget _buildLocationInfoPanel() {
    if (_placemark == null) {
      return const Center(
        child: Text(
          'No location information available',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    final Map<String, String?> placemarkInfo = {
      'Coordinates':
          '${_selectedPosition!.latitude.toStringAsFixed(6)}, ${_selectedPosition!.longitude.toStringAsFixed(6)}',
      'Address':
          '${_placemark!.street}, ${_placemark!.locality}, ${_placemark!.country}',
      'Name': _placemark!.name,
      'Street': _placemark!.street,
      'Thoroughfare': _placemark!.thoroughfare,
      'Subthoroughfare': _placemark!.subThoroughfare,
      'Locality (City)': _placemark!.locality,
      'Sublocality': _placemark!.subLocality,
      'Administrative Area': _placemark!.administrativeArea,
      'Subadmin Area': _placemark!.subAdministrativeArea,
      'Postal Code': _placemark!.postalCode,
      'Country': _placemark!.country,
      'ISO Country Code': _placemark!.isoCountryCode,
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ...placemarkInfo.entries.map((entry) {
            // Skip null or empty values
            if (entry.value == null || entry.value!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value!,
                      style: const TextStyle(height: 1.3),
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
