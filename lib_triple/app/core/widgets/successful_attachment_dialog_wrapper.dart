import 'package:flutter/material.dart';

import 'show_successful_attachment_dialog.dart';

class SuccessfulAttachmentDialogWrapper extends StatelessWidget {
  final Widget child;
  const SuccessfulAttachmentDialogWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => showSuccessfulAttachmentDialog(context: context), child: child);
  }
}
