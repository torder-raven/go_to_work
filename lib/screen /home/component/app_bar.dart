import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constant/text/label_text.dart';

AppBar renderAppBar({required IconButton iconButton}) {
  return AppBar(
    title: Text(
      LabelText.APP_BAR_TEXT,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.white,
    actions: [iconButton],
  );
}

IconButton goToMyLocation({required GoogleMapController? mapController}) {
  return IconButton(
    onPressed: () async {
      if (mapController == null) {
        return;
      }

      final location = await Geolocator.getCurrentPosition();

      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            location.latitude,
            location.longitude,
          ),
        ),
      );
    },
    color: Colors.blue,
    icon: Icon(
      Icons.my_location,
    ),
  );
}
