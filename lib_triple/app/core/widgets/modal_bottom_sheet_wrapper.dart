import 'package:flutter/material.dart';

import 'show_custom_modal_bottom_sheet.dart';

class ModalBottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final Widget content;
  final bool hasScrollIcon;
  const ModalBottomSheetWrapper({Key? key, required this.child, required this.content, this.hasScrollIcon = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomModalBottomSheet(
          context: context,
          content: (context) => content,
        );
      },
      child: child,
    );
  }
}
