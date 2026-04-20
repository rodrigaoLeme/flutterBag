import 'package:flutter/material.dart';

import 'show_custom_dialog.dart';

class DialogWrapper extends StatelessWidget {
  final Widget content;
  final Widget child;
  final EdgeInsets? insetPadding;
  const DialogWrapper({Key? key, required this.content, required this.child, this.insetPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCustomDialog(
            context: context,
            content: content,
            insetPadding: insetPadding,
          );
        },
        child: child);
  }
}
