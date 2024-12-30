import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class MapView extends StatelessWidget {
  final Future<String> cacheStr;
  final MapController mapController;
  final Function(LatLng) onMapTap;
  final List<Marker> markers;

  const MapView({
    super.key,
    required this.cacheStr,
    required this.mapController,
    required this.onMapTap,
    this.markers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: cacheStr,
      builder: (context, snapshot) {
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(31.9028, 35.2032),
            initialZoom: 13.0,
            onTap: (tapPosition, point) => onMapTap(point),
          ),
          children: [
            TileLayer(
              minZoom: 1,
              maxZoom: 20,
              keepBuffer: 6,
              tileProvider: FMTCStore('mapStore').getTileProvider(
                  settings: FMTCTileProviderSettings(
                      behavior: CacheBehavior.onlineFirst,
                      maxStoreLength: 1000)),
              urlTemplate:
                  "https://api.maptiler.com/maps/openstreetmap/256/{z}/{x}/{y}@2x.jpg?key=1nKMV4hTP8KKP9DAOtsl",
                  // "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}.png",
            ),
            if (markers.isNotEmpty) MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
