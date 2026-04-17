import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/helpers.dart';
import '../../modules.dart';
import 'exhibition_selector_section.dart';

class FilterExhibitionsModal extends StatefulWidget {
  final ExhibitionPresenter presenter;
  final ExhibitionsViewModel viewModel;

  const FilterExhibitionsModal({
    super.key,
    required this.presenter,
    required this.viewModel,
  });

  @override
  State<FilterExhibitionsModal> createState() => _FilterExhibitionsModalState();
}

class _FilterExhibitionsModalState extends State<FilterExhibitionsModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveLayout.of(context).hp(68),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.neutralLowMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Center(
              child: GcText(
                text: R.string.categories,
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h3,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ExhibitionSelectorSection(
              exhibitionGroups: widget.viewModel.exhibitionGroups,
              onChanged: (group) {
                if (group != null) {
                  widget.presenter.setCurrentFilter(group, widget.viewModel);
                  setState(() {});
                }
              },
            ),
          ),
          const Divider(
            height: 1,
            color: AppColors.neutralLight,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.presenter.clearFilter(widget.viewModel);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 117,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: GcText(
                      text: R.string.clearAllLabel,
                      textStyleEnum: GcTextStyleEnum.bold,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.primaryLight,
                      gcStyles: GcStyles.poppins,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: GcText(
                        text:
                            'Apply (${widget.viewModel.selectedDivisionGroups.length})',
                        textStyleEnum: GcTextStyleEnum.bold,
                        textSize: GcTextSizeEnum.callout,
                        color: AppColors.white,
                        gcStyles: GcStyles.poppins,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
