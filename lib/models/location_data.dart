
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({
    required this.latitude,
    required this.longitude,
  });


  LatLng get position {
    return LatLng(latitude, longitude);
  }
}
