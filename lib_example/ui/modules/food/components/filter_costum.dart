import 'package:flutter/material.dart';

import '../../../helpers/responsive/responsive_layout.dart';

class FilterCostum extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? customIcon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const FilterCostum({
    super.key,
    required this.text,
    this.icon,
    this.customIcon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveLayout.of(context);

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: responsive.wp(24),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(4.7),
            vertical: responsive.hp(0.6),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(1.6),
                ),
              ),
              if (icon != null || customIcon != null) ...[
                const SizedBox(width: 8.0),
                customIcon ??
                    Icon(
                      icon,
                      color: textColor,
                      size: responsive.ip(2.2),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
