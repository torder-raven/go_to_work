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

IconButton Location({required VoidCallback onPressed}) {
  return IconButton(
    onPressed: () async {
      onPressed();
    },
    color: Colors.blue,
    icon: Icon(
      Icons.my_location,
    ),
  );
}
