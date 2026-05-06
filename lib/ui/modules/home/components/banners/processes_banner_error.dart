import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/app_assets.dart';

class ProcessesBannerError extends StatelessWidget {
  final String message;

  const ProcessesBannerError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.exclamationIcon,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appStrings.processCardBannerAttention,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '$message Lorem ipsum dolor sit amet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
