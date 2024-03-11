import 'package:flutter/material.dart';

import '../../constant/strings.dart';

class ChoolCheckButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChoolCheckButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      child: const Text(
        HomeScreenString.BUTTON_TITLE,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
