import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color labelColor;
  final double? fontSize;
  const CustomTextButton({Key? key, required this.onTap, required this.label, required this.labelColor, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
