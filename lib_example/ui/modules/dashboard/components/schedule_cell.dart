import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../agenda/agenda_view_model.dart';
import '../../agenda/components/schedule_empty_cell.dart';
import 'schedule_items_section.dart';

class ScheduleCell extends StatelessWidget {
  final ScheduleTabs? viewModel;
  final double percent;
  final void Function()? onPressed;
  final ConnectionState connectionState;
  final Function(ScheduleViewModel?) goToDetails;

  const ScheduleCell({
    super.key,
    required this.viewModel,
    required this.onPressed,
    required this.percent,
    required this.connectionState,
    required this.goToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * percent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: onPressed,
                        child: GcText(
                          text: viewModel?.title ?? '',
                          textSize: GcTextSizeEnum.h3,
                          textStyleEnum: GcTextStyleEnum.bold,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.black,
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neutralLight,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          child: GcText(
                            text: R.string.seeAllButon,
                            textSize: GcTextSizeEnum.subhead,
                            textStyleEnum: GcTextStyleEnum.regular,
                            gcStyles: GcStyles.poppins,
                            color: AppColors.primaryLight,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (viewModel?.currentSection == null)
                  const ScheduleEmptyCell(),
                if (viewModel?.currentSection != null)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ScheduleItemsSection(
                          currentSection: viewModel?.currentSection,
                          goToDetails: goToDetails,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
