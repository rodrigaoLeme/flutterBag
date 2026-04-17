import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../agenda_view_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleViewModel? viewModel;
  final void Function(ScheduleViewModel?) onPressed;

  const ScheduleCard({
    super.key,
    required this.viewModel,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    final hasDescription = (viewModel?.description?.trim().isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: AppColors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Row(
              crossAxisAlignment: hasDescription
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: hasDescription ? 14 : 2),
                  child: SvgPicture.asset(
                    viewModel?.scheduleType?.icon ?? '',
                    color: AppColors.neutralLowMedium,
                    width: 18,
                    height: 18,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: hasDescription
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      GcText(
                        text: viewModel?.name ?? '',
                        textSize: GcTextSizeEnum.body,
                        textStyleEnum: GcTextStyleEnum.bold,
                        color: AppColors.primaryLight,
                        gcStyles: GcStyles.poppins,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      if (hasDescription) ...[
                        const SizedBox(height: 4.0),
                        SizedBox(
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColors.neutralLowMedium,
                                fontFamily: 'Poppins',
                              ),
                              children: (viewModel?.description ?? '')
                                  .split('\n')
                                  .map((line) => TextSpan(text: '$line\n'))
                                  .toList(),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    viewModel?.isFavorite == true
                        ? 'lib/ui/assets/images/icon/heart-solid.svg'
                        : 'lib/ui/assets/images/icon/heart-light.svg',
                    color: AppColors.primaryLight,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () => onPressed(viewModel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
