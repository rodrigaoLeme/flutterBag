import 'package:flutter/material.dart';

import 'custom_text_button.dart';
import 'show_custom_dialog.dart';

void showAddMoreDocumentsDialog({required BuildContext context, required VoidCallback onTapYes, required VoidCallback onTapNo}) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  showCustomDialog(
      context: context,
      content: Container(
        margin: const EdgeInsets.fromLTRB(22, 20, 22, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gostaria de adicionar mais fotos para este documento?',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF102C4E),
              ),
            ),
            const SizedBox(height: 8),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(
                  onTap: onTapYes,
                  label: 'Sim',
                  labelColor: primaryColor,
                  fontSize: 20,
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: 30,
                    thickness: 1,
                    color: const Color(0xFF707070).withOpacity(0.23),
                  ),
                ),
                CustomTextButton(
                  onTap: onTapNo,
                  label: 'Não',
                  labelColor: primaryColor,
                  fontSize: 20,
                ),
              ],
            ),
          ],
        ),
      ));
}
