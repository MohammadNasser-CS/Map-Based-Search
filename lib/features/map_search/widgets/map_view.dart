import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';

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
              tileProvider: CachedTileProvider(
                maxStale: const Duration(days: 30),
                store: HiveCacheStore(snapshot.data,
                    hiveBoxName: "HiveCacheStore"),
              ),
              urlTemplate: "http://127.0.0.1:7070/0/0/0.png",
            ),
            if (markers.isNotEmpty) MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
