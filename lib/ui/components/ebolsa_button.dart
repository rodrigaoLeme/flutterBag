import 'package:flutter/material.dart';

class EbolsaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;

  const EbolsaButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
