import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../helpers/app_assets.dart';
import '../../../../helpers/themes/app_colors.dart';

class ProcessesBannerWarning extends StatelessWidget {
  final String message;

  const ProcessesBannerWarning({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
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
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
