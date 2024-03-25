import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constant/values.dart';

class CustomGoogleMap extends StatelessWidget {
  static final CameraPosition initialPosition = CameraPosition(
    target: Values.companyLatLng,
    zoom: Values.ZOOM_DEFAULT,
  );
  static final double okDistance = Values.OK_DISTANCE_DEFAULT;
  static final Marker marker = Marker(
    markerId: MarkerId(Values.MARKER_ID_DEFAULT),
    position: Values.companyLatLng,
  );
  final Circle circle;
  final MapCreatedCallback onMapCreated;

  const CustomGoogleMap({
    required this.circle,
    required this.onMapCreated,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: onMapCreated,
      ),
    );
  }
}
