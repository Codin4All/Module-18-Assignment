
import 'package:geolocator/geolocator.dart';
import '../models/location_data.dart';

class LocationService {

  // Check location permission
  Future<bool> checkPermission() async {

    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationData> getCurrentLocation() async {

    Position position =
        await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
