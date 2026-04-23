import 'package:flutter/material.dart';

class EbolsaTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const EbolsaTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
