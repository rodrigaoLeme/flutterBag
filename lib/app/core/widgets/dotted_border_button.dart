import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBorderButton extends StatelessWidget {
  final String label;
  final Widget? leading;
  final Color? labelColor;
  final VoidCallback onTap;
  const DottedBorderButton({Key? key, required this.label, this.leading, this.labelColor, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(9),
      color: Theme.of(context).colorScheme.primary,
      strokeWidth: 0.5,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          splashColor: Colors.blue[400],
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 10)
                ],
                Text(
                  label,
                  style: TextStyle(color: labelColor, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
