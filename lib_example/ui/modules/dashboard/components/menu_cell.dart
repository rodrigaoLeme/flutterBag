import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../share/utils/app_color.dart';

class MenuCell extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color? iconColor;
  final TextStyle? style;

  const MenuCell({
    super.key,
    required this.iconPath,
    required this.title,
    required this.iconColor,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardLigth,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 20,
              width: 20,
              color: iconColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
