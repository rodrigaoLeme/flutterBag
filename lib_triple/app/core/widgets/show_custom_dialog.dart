import 'package:flutter/material.dart';

Future<T?> showCustomDialog<T>({required BuildContext context, required Widget content, EdgeInsets? insetPadding}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: insetPadding ?? const EdgeInsets.symmetric(vertical: 24, horizontal: 54),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: content,
      );
    },
  );
}
