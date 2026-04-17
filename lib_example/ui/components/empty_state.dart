import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../share/utils/app_color.dart';
import 'enum/design_system_enums.dart';
import 'gc_text.dart';
import 'themes/gc_styles.dart';

class EmptyState extends StatelessWidget {
  final String icon;
  final String title;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 52,
              height: 52,
              color: AppColors.neutralLowLight,
            ),
            const SizedBox(height: 16),
            GcText(
              text: title,
              textAlign: TextAlign.center,
              textSize: GcTextSizeEnum.callout,
              textStyleEnum: GcTextStyleEnum.regular,
              color: AppColors.neutralLowLight,
              gcStyles: GcStyles.poppins,
            ),
          ],
        ),
      ),
    );
  }
}
