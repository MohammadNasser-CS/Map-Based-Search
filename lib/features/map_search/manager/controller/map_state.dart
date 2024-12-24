// lib/map_search/manager/controller/map_state.dart

part of 'map_cubit.dart';

sealed class MapState {
  const MapState();
}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<MarkerModel> markers;
  final LatLng? cameraPosition; // Add this field

  MapLoaded({required this.markers, this.cameraPosition});
}

final class MapError extends MapState {
  final String message;
  const MapError({required this.message});
}

final class MapEmpty extends MapState {
  
}
class MapOffline extends MapState {
  final String message;

  const MapOffline({required this.message});
}