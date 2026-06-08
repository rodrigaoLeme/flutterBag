import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../helpers/themes/themes.dart';
import '../cards/processes_cards_result.dart';

class ProcessesBannerWarning extends StatelessWidget {
  final String message;
  final VoidCallback? onContinue;

  const ProcessesBannerWarning({
    super.key,
    required this.message,
    this.onContinue,
  });

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
          SvgPicture.asset(
            AppIcons.exclamationIcon,
            width: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appStrings.processCardBannerRegisterEnd,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onContinue,
            child: Container(
              // height: 35,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.onSurface,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(25),
                shape: BoxShape.rectangle,
              ),
              child: Text(
                appStrings.homeContinueProcess,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
