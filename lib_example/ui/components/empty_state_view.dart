import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';
import '../helpers/helpers.dart';
import '../helpers/i18n/resources.dart';
import 'enum/design_system_enums.dart';
import 'gc_text.dart';
import 'themes/gc_styles.dart';

class EmptyStateView extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final void Function()? onPressed;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.5,
      color: AppColors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  icon,
                  height: 48,
                  width: 48,
                  color: AppColors.primaryLight,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                  child: GcText(
                    text: title,
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.h1,
                    color: AppColors.primaryLight,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                GcText(
                  text: subtitle,
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.callout,
                  color: AppColors.neutralLowDark,
                  gcStyles: GcStyles.poppins,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32.0,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: onPressed,
                child: GcText(
                  text: R.string.tryAgainLabel,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.callout,
                  color: AppColors.primaryLight,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
