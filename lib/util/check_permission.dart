import 'package:geolocator/geolocator.dart';

import '../const/strings.dart';

class CheckPermission {
  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return Strings.LOCATION_ENABLE_MSG;
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return Strings.LOCATION_PERMISSION_MSG;
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return Strings.LOCATION_SETTING_MSG;
    }

    return Strings.LOCATION_OK_MSG;
  }
}
