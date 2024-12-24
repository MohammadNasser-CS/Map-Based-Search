import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_based_search/features/map_search/models/marker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_services_interface.dart';

class MapServicesImplementation implements MapServicesInterface {
  @override
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  Future<List<MarkerModel>> fetchMarkersFromAPI(String category) async {
    // Filter markers by category
    return dummyMarkers.where((marker) => marker.category == category).toList();
  }

  @override
Future<void> saveMarkersOffline(List<MarkerModel> markers) async {
  final prefs = await SharedPreferences.getInstance();
  final markersJson = jsonEncode(markers
      .map((marker) => {'lat': marker.lat, 'lon': marker.lon})
      .toList());
  prefs.setString('markers', markersJson);
}
  @override
 Future<List<MarkerModel>> loadMarkersOffline() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final storedMarkers = prefs.getString('markers');

    if (storedMarkers != null) {
      final List<dynamic> data = jsonDecode(storedMarkers);
      return data.map((json) => MarkerModel.fromJson(json)).toList();
    }
  } catch (e) {
    debugPrint("Error loading stored markers: $e");
  }
  return []; //empty list if anything fails
}
  
  @override
  Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled. Please enable them.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied. Please allow them.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition();
}

}