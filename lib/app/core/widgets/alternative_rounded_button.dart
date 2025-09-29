import 'package:flutter/material.dart';

class AlternativeRoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? labelColor;
  const AlternativeRoundedButton({Key? key, this.onTap, required this.label, this.backgroundColor, this.labelColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue[200];
            }
            return backgroundColor ?? const Color(0xFFF1FAFF);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 10))),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: labelColor ?? Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
      ),
    );
  }
}
