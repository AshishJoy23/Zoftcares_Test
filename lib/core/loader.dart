import 'package:flutter/material.dart';

class Loader {
  static showLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.indigo,
        ),
      ),
    );
  }

  // static stopLoader() {
  //   Navigator.pop(context);
  // }
}
