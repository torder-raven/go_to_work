import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../const/locations.dart';
import '../const/strings.dart';

class CustomGoogleMap extends StatefulWidget {
  late int myCurrentPosition;

  @override
  State<StatefulWidget> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? googleMapController;

  static final CameraPosition initialPosition = CameraPosition(
    target: Locations.companyLatLng,
    zoom: 15,
  );
  static final Marker companyLocationMarker = Marker(
    markerId: const MarkerId(Strings.COMPANY),
    position: Locations.companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialPosition,
      markers: {companyLocationMarker},
      circles: createCircles(widget.myCurrentPosition, Locations.myCurrentLocations),
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  Set<Circle> createCircles(
      int myCurrentPosition, List<LatLng> myCurrentLocations) {
    Set<Circle> circles = <Circle>{};

    for (int i = 0; i < myCurrentLocations.length; i++) {
      LatLng center = myCurrentLocations[i];
      Color fillColor = (i == myCurrentPosition) ? Colors.red : Colors.blue;
      double radius = 100;

      Circle circle = Circle(
        circleId: CircleId("$i"),
        center: center,
        fillColor: fillColor.withOpacity(0.5),
        radius: radius,
        strokeWidth: 0,
      );

      circles.add(circle);
    }

    return circles;
  }
}
