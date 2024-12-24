import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_based_search/features/map_search/models/marker_model.dart';

abstract class MapServicesInterface {
  Future<LatLng> getCurrentLocation();
  Future<List<MarkerModel>> fetchMarkersFromAPI(String category);
  Future<void> saveMarkersOffline(List<MarkerModel> markers);
  Future<List<MarkerModel>> loadMarkersOffline();
  Future<Position> determinePosition();
}