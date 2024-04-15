import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

final modalScaffoldKey = GlobalKey<ScaffoldState>();

class Utils {
  Utils._();

  static void showSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
          behavior: SnackBarBehavior.fixed,
        ),
      );
  }

  static Future<FilePickerResult?> pickImage() async {
    final image = await FilePicker.platform.pickFiles(type: FileType.image);
    return image;
  }
}
