// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';

class NavUtils {
  NavUtils._();

  static Future<void> to(BuildContext context, Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void back(BuildContext context) => Navigator.of(context).pop();

  static Future<void> offAll(BuildContext context, Widget page) async {
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }
}
