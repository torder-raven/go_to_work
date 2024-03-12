import 'package:flutter/material.dart';

import '../../constant/strings.dart';

AppBar homeAppBar({
  required VoidCallback onCurrentPositionPressed,
}) {
  return AppBar(
    title: const Text(
      HomeScreenString.TITLE,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.white,
    actions: [
      IconButton(
        onPressed: onCurrentPositionPressed,
        color: Colors.blue,
        icon: const Icon(
          Icons.my_location,
        ),
      ),
    ],
  );
}
