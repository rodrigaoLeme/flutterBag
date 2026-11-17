import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/themes/themes.dart';

class EbolsaCheckProofsIcons extends StatelessWidget {
  final bool needsReview;
  final bool isComplete;

  const EbolsaCheckProofsIcons({
    super.key,
    required this.needsReview,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (isComplete) {
      return Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            AppIcons.greenCheckIcon,
            width: 15,
            height: 11,
            //color: AppColors.success,
          ),
        ),
      );
    }
    if (needsReview) {
      return SvgPicture.asset(
        AppIcons.yellowAtentionIcon,
        width: 32,
        height: 28,
      );
    }
    return const SizedBox(width: 0);
  }
}
