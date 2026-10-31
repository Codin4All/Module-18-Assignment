
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location_data.dart';

class MapWidget extends StatelessWidget {

  final LocationData? currentLocation;
  final List<LatLng> locationHistory;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.currentLocation,
    required this.locationHistory,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {

    return GoogleMap(

      initialCameraPosition: const CameraPosition(
        target: LatLng(23.8103, 90.4125),
        zoom: 12,
      ),

      onMapCreated: onMapCreated,


      markers: currentLocation == null
          ? {}
          : {
              Marker(
                markerId: const MarkerId('current_location'),

                position: currentLocation!.position,

                infoWindow: InfoWindow(
                  title: 'My current location',
                  snippet:
                      'Latitude: ${currentLocation!.latitude}, '
                      'Longitude: ${currentLocation!.longitude}',
                ),
              ),
            },


      polylines: {
        Polyline(
          polylineId: const PolylineId('location_tracking'),
          points: locationHistory,
          color: Colors.blue,
          width: 5,
        ),
      },

      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }
}
