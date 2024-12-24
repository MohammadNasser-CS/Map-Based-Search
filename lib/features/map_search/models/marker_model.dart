class MarkerModel {
  final String id;  // Added ID for uniqueness
  final double lat;
  final double lon;
  final String? category;

  MarkerModel({
    required this.id,  // Required ID for each marker
    required this.lat,
    required this.lon,
    this.category,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json['id'],  // Parse the ID from the JSON
      lat: json['lat'],
      lon: json['lon'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,  // Include ID in the JSON
      'lat': lat,
      'lon': lon,
      'category': category,
    };
  }
}

List<MarkerModel> dummyMarkers = [
  // Palestinian Coordinates
  MarkerModel(id: '1', lat: 31.7683, lon: 35.2137, category: 'Restaurant'), // Jerusalem
  MarkerModel(id: '2', lat: 31.9481, lon: 35.2271, category: 'Museum'),     // Bethlehem
  MarkerModel(id: '3', lat: 32.0933, lon: 35.2919, category: 'Park'),        // Nablus
  MarkerModel(id: '4', lat: 31.5535, lon: 34.4721, category: 'Restaurant'),  // Gaza City
  MarkerModel(id: '5', lat: 32.0316, lon: 35.1130, category: 'Park'),        // Ramallah
  MarkerModel(id: '6', lat: 31.8840, lon: 35.0956, category: 'Museum'),      // Hebron
  MarkerModel(id: '7', lat: 31.2470, lon: 35.0150, category: 'Park'),        // Jericho
  MarkerModel(id: '8', lat: 32.0801, lon: 35.0655, category: 'Restaurant'),  // Jenin
  MarkerModel(id: '9', lat: 32.0850, lon: 35.2041, category: 'Museum'),      // Tulkarem
  MarkerModel(id: '10', lat: 31.6176, lon: 34.9612, category: 'Park'),       // Rafah
  MarkerModel(id: '11', lat: 32.2110, lon: 35.1628, category: 'Restaurant'), // Qalqilya
  MarkerModel(id: '12', lat: 31.9732, lon: 35.2150, category: 'Museum'),     // Beit Jala
  MarkerModel(id: '13', lat: 32.0437, lon: 35.1562, category: 'Park'),       // Tubas
  MarkerModel(id: '14', lat: 31.8493, lon: 35.0194, category: 'Restaurant'), // Nablus
  MarkerModel(id: '15', lat: 32.0816, lon: 35.0981, category: 'Park'),       // Tulkarem
];