import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../agenda/agenda_view_model.dart';

class ScheduleItemsCell extends StatelessWidget {
  final ScheduleViewModel? viewModel;
  final Function(ScheduleViewModel?) goToDetails;
  const ScheduleItemsCell({
    super.key,
    required this.viewModel,
    required this.goToDetails,
  });
  @override
  Widget build(BuildContext context) {
    final hasDescription = (viewModel?.description?.trim().isNotEmpty ?? false);

    return GestureDetector(
      onTap: () {
        goToDetails(viewModel);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: hasDescription
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SvgPicture.asset(
                      viewModel?.scheduleType?.icon ?? '',
                      color: AppColors.neutralLowMedium,
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GcText(
                          text: viewModel?.name ?? '',
                          textSize: GcTextSizeEnum.callout,
                          textStyleEnum: GcTextStyleEnum.regular,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.primaryLight,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        GcText(
                          text: viewModel?.description ?? '',
                          textSize: GcTextSizeEnum.footnote,
                          textStyleEnum: GcTextStyleEnum.regular,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.neutralLowMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SvgPicture.asset(
                      viewModel?.scheduleType?.icon ?? '',
                      color: AppColors.neutralLowMedium,
                      height: 16,
                      width: 16,
                    ),
                  ),
                  Expanded(
                    child: GcText(
                      text: viewModel?.name ?? '',
                      textSize: GcTextSizeEnum.callout,
                      textStyleEnum: GcTextStyleEnum.regular,
                      gcStyles: GcStyles.poppins,
                      color: AppColors.primaryLight,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
