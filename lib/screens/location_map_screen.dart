
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location_data.dart';
import '../services/location_service.dart';
import '../widgets/map_widget.dart';
import '../widgets/location_info.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() =>
      _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {

  final LocationService locationService = LocationService();

  GoogleMapController? mapController;


  LocationData? currentLocation;

  List<LatLng> locationHistory = [];


  Timer? locationTimer;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    startTracking();
  }


  Future<void> startTracking() async {

    try {

      bool permission =
          await locationService.checkPermission();

      if (!permission) {
        if (!mounted) return;

        setState(() {
          errorMessage =
              'Please enable GPS and location permission';
        });

        return;
      }

      await updateLocation();

   
      locationTimer = Timer.periodic(
        const Duration(seconds: 10),
        (timer) {
          updateLocation();
        },
      );

    } catch (e) {

      if (!mounted) return;

      setState(() {
        errorMessage = 'Location error: $e';
      });
    }
  }

  Future<void> updateLocation() async {

    try {

      LocationData location =
          await locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {

        currentLocation = location;


        locationHistory.add(location.position);

        errorMessage = '';

      });

      moveCamera(location.position);

    } catch (e) {

      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to get location';
      });
    }
  }


  void moveCamera(LatLng position) {

    if (mapController != null) {

      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          position,
          17,
        ),
      );
    }
  }


  void onMapCreated(GoogleMapController controller) {

    mapController = controller;

    if (currentLocation != null) {
      moveCamera(currentLocation!.position);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Google Maps Location Tracking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [

          Expanded(
            child: MapWidget(
              currentLocation: currentLocation,
              locationHistory: locationHistory,
              onMapCreated: onMapCreated,
            ),
          ),

        
          LocationInfo(
            location: currentLocation,
            trackingPoints: locationHistory.length,
            errorMessage: errorMessage,
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {

    locationTimer?.cancel();

    mapController?.dispose();

    super.dispose();
  }
}
