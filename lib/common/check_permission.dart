import 'package:geolocator/geolocator.dart';

import '../screen /constant/text/dialog_text.dart';

Future<String> checkPermission() async {
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission checkedPermission = await Geolocator.checkPermission();

  if (!isLocationEnabled) {
    return DialogText.REQUEST_LOCATION_SERVICE;
  }

  if (checkedPermission == LocationPermission.denied) {
    checkedPermission = await Geolocator.requestPermission();

    if (checkedPermission == LocationPermission.denied) {
      return DialogText.REQUEST_PERMISSION;
    }
  }

  if (checkedPermission == LocationPermission.deniedForever) {
    return DialogText.REQUEST_PERMISSION_DIRECTLY;
  }

  return DialogText.REQUEST_PERMISSION_GRANTED;
}