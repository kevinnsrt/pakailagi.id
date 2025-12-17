import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class TopNotif {
  static void success(BuildContext context, String msg) {
    Flushbar(
      message: msg,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  static void error(BuildContext context, String msg) {
    Flushbar(
      message: msg,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
