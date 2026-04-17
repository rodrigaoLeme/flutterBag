import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../agenda_view_model.dart';
import 'schedule_card.dart';

class ScheduleSection extends StatelessWidget {
  final ScheduleItemViewModel? viewModel;
  final void Function(ScheduleViewModel?) onPressed;
  final void Function(ScheduleViewModel?) goToDetails;

  const ScheduleSection({
    super.key,
    required this.viewModel,
    required this.onPressed,
    required this.goToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              GcText(
                text: viewModel?.title ?? '',
                textSize: GcTextSizeEnum.h4,
                textStyleEnum: GcTextStyleEnum.bold,
                color: AppColors.neutralLowDark,
                gcStyles: GcStyles.poppins,
              ),
              const SizedBox(width: 8.0),
              if (viewModel?.showLiveBadge == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  decoration: BoxDecoration(
                    color: AppColors.redMedium,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: GcText(
                    text: R.string.liveLabel,
                    textSize: GcTextSizeEnum.caption1,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.white,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: viewModel?.filter.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final item = viewModel?.filter[index];
            return GestureDetector(
              onTap: () {
                goToDetails(item);
              },
              child: ScheduleCard(
                viewModel: item,
                onPressed: onPressed,
              ),
            );
          },
        ),
      ],
    );
  }
}
