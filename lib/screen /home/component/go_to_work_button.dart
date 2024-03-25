import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/text/label_text.dart';

class ChoolCheckButton extends StatelessWidget {
  final bool isWithinRange;
  final VoidCallback onPressed;
  final bool choolCheckDone;

  const ChoolCheckButton({
    required this.isWithinRange,
    required this.onPressed,
    required this.choolCheckDone,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timelapse_outlined,
            size: 50.0,
            //todo: 수정
            color: choolCheckDone
                ? Colors.green
                : isWithinRange
                ? Colors.blue
                : Colors.red,
          ),
          const SizedBox(height: 20.0),
          if (!choolCheckDone && isWithinRange)
            TextButton(
              onPressed: onPressed,
              child: Text(LabelText.GO_TO_WORK),
            ),
        ],
      ),
    );
  }
}