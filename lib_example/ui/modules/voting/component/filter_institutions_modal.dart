import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/helpers.dart';
import '../voting_presenter.dart';
import '../voting_view_model.dart';
import 'ministries_section.dart';

// ignore: must_be_immutable
class FilterInstitutionsModal extends StatefulWidget {
  final VotingPresenter presenter;
  VotingsViewModel? viewModel;

  FilterInstitutionsModal({
    super.key,
    required this.presenter,
    required this.viewModel,
  });

  @override
  State<FilterInstitutionsModal> createState() =>
      _FilterInstitutionsModalState();
}

class _FilterInstitutionsModalState extends State<FilterInstitutionsModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveLayout.of(context).hp(75),
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
                text: R.string.filterByLabel,
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h3,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
          ),
          Expanded(
            child: MinistriesSection(
              viewModel: widget.viewModel,
              onChanged: (group) {
                if (group != null) {
                  widget.viewModel =
                      widget.presenter.setFilter(widget.viewModel, group);
                  setState(() {});
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.presenter.clealAllFilters(widget.viewModel);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 16),
                    width: 124,
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
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
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: GcText(
                        text:
                            '${R.string.applyLabel} (${widget.viewModel?.selectedFilterCount})',
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
