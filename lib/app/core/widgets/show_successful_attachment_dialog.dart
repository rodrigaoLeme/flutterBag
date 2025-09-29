import 'package:flutter/material.dart';

import '../icons/ebolsas_icons_icons.dart';
import 'show_custom_dialog.dart';

Future<T?> showSuccessfulAttachmentDialog<T>({required BuildContext context}) {
  return showCustomDialog<T>(
    context: context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 88, vertical: 24),
    content: Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Documentos anexados com sucesso!',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF102C4E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 13),
          Icon(
            EbolsasIcons.check,
            color: Color(0xFF00A357),
            size: 25.72,
          ),
        ],
      ),
    ),
  );
}
