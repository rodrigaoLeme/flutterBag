import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/app_assets.dart';
import '../../../../helpers/themes/app_colors.dart';

class ProcessesBannerPendingDocumentsWarning extends StatelessWidget {
  final String message;

  const ProcessesBannerPendingDocumentsWarning(
      {super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.exclamationIcon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3 ${appStrings.processCardBannerPendindDocumentsPlural}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Container(
            width: 35,
            height: 35,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.onSurface,
                width: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(AppIcons.arrowRightIcon),
          )
        ],
      ),
    );
  }
}
