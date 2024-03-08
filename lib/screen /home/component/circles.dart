import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constant/values.dart';

const LatLng companyLatLng = LatLng(
  37.5233273,
  126.921252,
);

const double okDistance = 100;

Circle withinDistanceCircle = Circle(
  circleId: CircleId(Values.CIRCLE_ID_WITHIN),
  center: companyLatLng,
  fillColor: Colors.blue.withOpacity(0.5),
  radius: okDistance,
  strokeColor: Colors.blue,
  strokeWidth: 1,
);

Circle notWithinDistanceCircle = Circle(
  circleId: CircleId(Values.CIRCLE_ID_NOT_WITHIN),
  center: companyLatLng,
  fillColor: Colors.red.withOpacity(0.5),
  radius: okDistance,
  strokeColor: Colors.red,
  strokeWidth: 1,
);

Circle checkDoneCircle = Circle(
  circleId: CircleId(Values.CIRCLE_ID_NOT_CHECK_DONE),
  center: companyLatLng,
  fillColor: Colors.green.withOpacity(0.5),
  radius: okDistance,
  strokeColor: Colors.green,
  strokeWidth: 1,
);