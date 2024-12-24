import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_based_search/features/map_search/models/marker_model.dart';
import 'package:map_based_search/features/map_search/services/map_services_implementation.dart';
import 'package:map_based_search/features/map_search/services/map_services_interface.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  final MapServicesInterface _mapServices = MapServicesImplementation();
  Future<void> loadInitialLocation() async {
    try {
      emit(MapLoading());
      final currentLocation = await _mapServices.getCurrentLocation();
      final region = RectangleRegion(
    LatLngBounds(LatLng(32.5521, 34.2191), LatLng(31.2200, 35.5739)),
);
      final cacheManager = FMTCStore('mapStore');
      await cacheManager.manage.removeTilesOlderThan(expiry: DateTime.timestamp().subtract(Duration(minutes: 30)));
      final downloadableRegion = region.toDownloadable(
        minZoom: 1,
        maxZoom: 18,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
      );
      // Download tiles for the Palestine bounding box
      await cacheManager.download.startForeground(
        region: downloadableRegion, // Region to cache
        maxBufferLength: 1000,
        skipExistingTiles: true,
      );
      debugPrint("Tiles successfully cached for the region!");
      emit(MapLoaded(
        cameraPosition: currentLocation,
        markers: [],
      ));
    } catch (e) {
      debugPrint("Error fetching current location: $e");
      await _checkForCachedMarkers();
    }
  }

  Future<void> searchMarkersByCategory(String category) async {
    emit(MapLoading());
    try {
      // Fetch markers from the service based on category
      final fetchedMarkers = await _mapServices.fetchMarkersFromAPI(category);

      if (fetchedMarkers.isEmpty) {
        emit(MapEmpty());
      } else {
        // Save markers for offline use
        await _mapServices.saveMarkersOffline(fetchedMarkers);
        final firstMarker = fetchedMarkers.first;

        emit(MapLoaded(
          markers: fetchedMarkers,
          cameraPosition: LatLng(firstMarker.lat, firstMarker.lon),
        ));
      }
    } catch (e) {
      debugPrint("Error fetching markers: $e");
      // Offline fallback - Load markers from local cache
      emit(const MapError(
          message: 'Failed to load markers. Showing offline data.'));
      await _checkForCachedMarkers();
    }
  }

  Future<void> resetMarkers() async {
    emit(MapLoading());
    try {
      Position position = await _mapServices.determinePosition();
      emit(MapLoaded(
        markers: [
          MarkerModel(
              id: position.latitude.toString() + position.longitude.toString(),
              lat: position.latitude,
              lon: position.longitude)
        ],
        cameraPosition: LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      debugPrint("Error in resetting location: $e");
      emit(const MapError(
          message:
              'Location cannot be fetched. Please ensure GPS is enabled.'));
      // Show default location or the last known position if available
      LatLng fallbackLocation = const LatLng(
          37.7749, -122.4194); // Example: San Francisco coordinates
      emit(MapLoaded(
        markers: [
          MarkerModel(
              id: fallbackLocation.latitude.toString() +
                  fallbackLocation.longitude.toString(),
              lat: fallbackLocation.latitude,
              lon: fallbackLocation.longitude)
        ],
        cameraPosition: fallbackLocation,
      ));
    }
  }

// Add a marker on tap
  void addMarkerOnTap(double latitude, double longitude) {
    if (state is MapLoaded) {
      final currentMarkers = (state as MapLoaded).markers;

      // Create a new marker with latitude and longitude
      final newMarker = MarkerModel(
          id: latitude.toString() + longitude.toString(),
          lat: latitude,
          lon: longitude);

      // Add the new marker to the current list
      final updatedMarkers = List<MarkerModel>.from(currentMarkers)
        ..add(newMarker);

      // Emit the updated state with the new marker
      emit(MapLoaded(markers: updatedMarkers));
    } else {
      // If no markers are loaded yet, create the first marker
      emit(MapLoaded(markers: [
        MarkerModel(
            id: latitude.toString() + longitude.toString(),
            lat: latitude,
            lon: longitude)
      ]));
    }
  }

  Future<void> _checkForCachedMarkers() async {
    try {
      // Try loading offline markers
      final offlineMarkers = await _mapServices.loadMarkersOffline();
      if (offlineMarkers.isEmpty) {
        emit(MapEmpty()); // Emit empty state if no markers are found
      } else {
        emit(const MapOffline(
            message: 'No internet connection, showing offline data.'));
        emit(MapLoaded(
          markers: offlineMarkers,
          cameraPosition:
              LatLng(offlineMarkers.first.lat, offlineMarkers.first.lon),
        ));
      }
    } catch (e) {
      emit(MapError(message: 'Failed to load offline markers: $e'));
      debugPrint('Error loading offline markers: $e');
    }
  }
}
