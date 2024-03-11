import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  void showAlertDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          content: Text(msg),
        );
      },
    );
  }
}