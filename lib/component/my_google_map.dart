import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const MyGoogleMap(
      {required this.initialPosition,
      required this.circle,
      required this.marker,
      required this.onMapCreated,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: GoogleMap(
        circles: {circle},
        markers: {marker},
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: initialPosition,
        onMapCreated: onMapCreated,
      ),
    );
  }
}
