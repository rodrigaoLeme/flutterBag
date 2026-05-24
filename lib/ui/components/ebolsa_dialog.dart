import 'package:flutter/material.dart';

import '../helpers/themes/themes.dart';
import 'components.dart';

class EbolsaDialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const EbolsaDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

class EbolsaDialog extends StatelessWidget {
  final String title;
  final String description;
  final List<EbolsaDialogAction> actions;
  final bool barrierDismissible;

  const EbolsaDialog({
    super.key,
    required this.title,
    required this.description,
    required this.actions,
    this.barrierDismissible = false,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    required List<EbolsaDialogAction> actions,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => EbolsaDialog(
        title: title,
        description: description,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.titleLarge,
      ),
      content: Text(
        description,
        style: AppTextStyles.bodyMedium,
      ),
      actions: actions
          .map(
            (action) => action.isPrimary
                ? EbolsaButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      action.onPressed();
                    },
                    label: action.label,
                  )
                : EbolsaTextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      action.onPressed();
                    },
                    label: action.label,
                  ),
          )
          .toList(),
    );
  }
}

class EbolsaDialogWithCancel extends StatelessWidget {
  final String title;
  final String description;
  final List<EbolsaDialogAction> actions;
  final bool barrierDismissible;

  const EbolsaDialogWithCancel({
    super.key,
    required this.title,
    required this.description,
    required this.actions,
    this.barrierDismissible = false,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    required List<EbolsaDialogAction> actions,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => EbolsaDialogWithCancel(
        title: title,
        description: description,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.titleLarge,
      ),
      content: Text(
        description,
        style: AppTextStyles.bodyMedium,
      ),
      actions: actions
          .map(
            (action) => action.isPrimary
                ? EbolsaTextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      action.onPressed();
                    },
                    label: action.label,
                  )
                : EbolsaTextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      action.onPressed();
                    },
                    label: action.label,
                    isSecondary: true,
                  ),
          )
          .toList(),
    );
  }
}
