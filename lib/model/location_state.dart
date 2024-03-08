

import 'package:geolocator/geolocator.dart';

import '../resource/strings.dart';

sealed class LocationState {
  bool isLocationEnabled;
  LocationPermission locationPermission;
  String message;

  LocationState({
    required this.isLocationEnabled,
    required this.locationPermission,
    required this.message,
  });
}

class LocationDisabled implements LocationState {
  @override
  bool isLocationEnabled = false;

  @override
  LocationPermission locationPermission = LocationPermission.denied;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_LOCATION_DISABLE;
}

class Denied implements LocationState {
  @override
  bool isLocationEnabled = true;

  @override
  LocationPermission locationPermission = LocationPermission.denied;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_DENIED;
}

class DeniedForever implements LocationState {
  @override
  bool isLocationEnabled = true;

  @override
  LocationPermission locationPermission = LocationPermission.deniedForever;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_DENIED_FOREVER;
}

class WhileInUse implements LocationState {
  @override
  bool isLocationEnabled = true;

  @override
  LocationPermission locationPermission = LocationPermission.whileInUse;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_WHILE_IN_USE;
}

class Always implements LocationState {
  @override
  bool isLocationEnabled = true;

  @override
  LocationPermission locationPermission = LocationPermission.always;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_ALWAYS;
}

class UnableToDetermine implements LocationState {
  @override
  bool isLocationEnabled = true;

  @override
  LocationPermission locationPermission = LocationPermission.unableToDetermine;

  @override
  String message = Strings.MESSAGE_LOCATION_STATE_UNABLE_TO_DETERMINE;
}

extension LocationPermissions on LocationPermission {
  LocationState toLocationState() => switch (this) {
    LocationPermission.denied => Denied(),
    LocationPermission.deniedForever => DeniedForever(),
    LocationPermission.whileInUse => WhileInUse(),
    LocationPermission.always => Always(),
    LocationPermission.unableToDetermine => UnableToDetermine()
  };
}
