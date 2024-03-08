import 'package:google_maps_flutter/google_maps_flutter.dart';

class Values {
  const Values._();

  static final CIRCLE_ID_WITHIN = "withinDistanceCircle";
  static final CIRCLE_ID_NOT_WITHIN = "notWithinDistanceCircle";
  static final CIRCLE_ID_NOT_CHECK_DONE = "checkDoneCircle";
  static final MARKER_ID_DEFAULT = "marker";
  static final OK_DISTANCE_DEFAULT = 100.0;
  static final ZOOM_DEFAULT = 15.0;
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
}