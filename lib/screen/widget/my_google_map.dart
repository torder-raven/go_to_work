import 'package:flutter/material.dart';
import 'package:go_to_work/constant/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatefulWidget {
  final LatLng baseLntLng;
  final MapCreatedCallback onMapCreated;
  final bool isWithin;
  final bool isDone;

  const MyGoogleMap({
    super.key,
    required this.baseLntLng,
    required this.onMapCreated,
    required this.isWithin,
    required this.isDone,
  });

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  GoogleMapController? googleMapController;

  late Marker baseMarker;
  late Color baseCircleColor;

  @override
  void initState() {
    super.initState();

    baseMarker = Marker(
      markerId: const MarkerId(MyGoogleMapConstants.BASE_MARKER_ID),
      position: widget.baseLntLng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.baseLntLng,
        zoom: 17,
      ),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      circles: {
        baseCircle(done: widget.isDone, withinRanged: widget.isWithin),
      },
      markers: {
        baseMarker,
      },
      onMapCreated: onGoogleMapCreated,
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  Circle baseCircle({
    required bool done,
    required bool withinRanged,
  }) {
    Color color;

    if (done) {
      color = Colors.green;
    } else {
      if (withinRanged) {
        color = Colors.blue;
      } else {
        color = Colors.red;
      }
    }

    return Circle(
      circleId: const CircleId(MyGoogleMapConstants.BASE_CIRCLE_ID),
      center: widget.baseLntLng,
      radius: MyGoogleMapConstants.OK_DISTANCE,
      fillColor: color.withOpacity(0.1),
      strokeColor: color,
      strokeWidth: 1,
    );
  }

  void onGoogleMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    widget.onMapCreated(controller);
  }
}
