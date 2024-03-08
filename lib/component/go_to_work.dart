import 'package:flutter/material.dart';
import 'package:go_to_work/resource/strings.dart';

class GoToWorkButton extends StatelessWidget {
  final bool isWithInRange;
  final bool isCheckDone;
  final VoidCallback onGoToWorkPressed;
  final VoidCallback onGoToHomePressed;

  const GoToWorkButton({
    required this.isWithInRange,
    required this.isCheckDone,
    required this.onGoToWorkPressed,
    required this.onGoToHomePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.timelapse,
              color: isCheckDone
                  ? Colors.green
                  : (isWithInRange ? Colors.blue : Colors.red),
              size: 60.0,
            ),
            const SizedBox(
              height: 20,
            ),
            if (!isCheckDone && isWithInRange)
              TextButton(
                onPressed: onGoToWorkPressed,
                child: const Text(
                  Strings.TITLE_GO_TO_WORK,
                ),
              ),
            if (!isWithInRange)
              const TextButton(
                onPressed: null,
                child: Text(
                  Strings.TEXT_OUT_OF_RANGE,
                ),
              ),
            if (isCheckDone && isWithInRange)
              TextButton(
                onPressed: onGoToHomePressed,
                child: const Text(
                  Strings.TEXT_GO_TO_HOME,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
