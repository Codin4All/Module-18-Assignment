
import 'package:flutter/material.dart';
import '../models/location_data.dart';

class LocationInfo extends StatelessWidget {

  final LocationData? location;
  final int trackingPoints;
  final String errorMessage;

  const LocationInfo({
    super.key,
    required this.location,
    required this.trackingPoints,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: Colors.blue.shade50,

      child: location == null
          ? Text(
              errorMessage.isEmpty
                  ? 'Getting current location...'
                  : errorMessage,
              textAlign: TextAlign.center,
            )
          : Column(
              children: [

                const Text(
                  'My Current Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text('Latitude: ${location!.latitude}'),

                Text('Longitude: ${location!.longitude}'),

                const SizedBox(height: 5),

                Text('Tracking Points: $trackingPoints'),
              ],
            ),
    );
  }
}
