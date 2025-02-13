import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_based_search/core/utils/app_color.dart';
import 'package:map_based_search/features/map_search/manager/controller/map_cubit.dart';
import 'package:map_based_search/features/map_search/widgets/map_view.dart';
import 'package:map_based_search/features/map_search/widgets/search_field.dart';
import 'package:path_provider/path_provider.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final Future<String> _cacheStr = _getPath();
  static Future<String> _getPath() async {
    final cacheDir = await getTemporaryDirectory();
    return cacheDir.path;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<MapCubit>(context);
    return SafeArea(
      child: Stack(
        children: [
          BlocConsumer<MapCubit, MapState>(
            listener: (context, state) {
              // Listen to the MapOffline state and show a message
              if (state is MapOffline) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message), // Display offline message
                  duration: const Duration(seconds: 3),
                ));
              }
            },
            builder: (context, state) {
              if (state is MapLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MapError) {
                return Center(child: Text(state.message));
              } else if (state is MapLoaded) {
                if (state.cameraPosition != null) {
                  _mapController.move(state.cameraPosition!, 13.0);
                }
                return MapView(
                  cacheStr: _cacheStr,
                  mapController: _mapController,
                  onMapTap: (LatLng point) =>
                      cubit.addMarkerOnTap(point.latitude, point.longitude),
                  markers: state.markers
                      .map((marker) => Marker(
                            point: LatLng(marker.lat, marker.lon),
                            child: const Icon(Icons.location_on,
                                color: AppColor.red, size: 40),
                          ))
                      .toList(),
                );
              } else {
                return MapView(
                  cacheStr: _cacheStr,
                  mapController: _mapController,
                  onMapTap: (LatLng point) =>
                      cubit.addMarkerOnTap(point.latitude, point.longitude),
                );
              }
            },
          ),
          SearchField(
              controller: _searchController,
              onSearch: () async =>
                  {await cubit.searchMarkersByCategory(_searchController.text)},
              onSubmit: (value) async =>
                  {await cubit.searchMarkersByCategory(value)}),
          // Combined Zoom and Current Location Controls
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black38,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Zoom In Button
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColor.black),
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      debugPrint('$currentZoom');
                      if (currentZoom < 19) {
                        _mapController.move(
                            _mapController.camera.center, currentZoom + 1);
                      }
                    },
                  ),

                  const Divider(height: 1, thickness: 1, color: AppColor.grey),
                  // Zoom Out Button
                  IconButton(
                    icon: const Icon(Icons.remove, color: AppColor.black),
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      debugPrint('$currentZoom');
                      if (currentZoom > 3) {
                        _mapController.move(
                            _mapController.camera.center, currentZoom - 1);
                      }
                    },
                  ),
                  const Divider(height: 1, thickness: 1, color: AppColor.grey),
                  // Current Location Button
                  IconButton(
                    icon: const Icon(Icons.my_location, color: AppColor.black),
                    onPressed: cubit.resetMarkers,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
