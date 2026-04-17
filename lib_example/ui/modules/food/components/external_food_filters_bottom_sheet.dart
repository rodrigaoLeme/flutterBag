import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/helpers.dart';
import '../food_presenter.dart';
import '../food_view_model.dart';
import 'filter_costum.dart';

// ignore: must_be_immutable
class ExternalFoodFiltersBottomSheet extends StatefulWidget {
  final FoodPresenter presenter;
  FoodViewModel viewModel;

  ExternalFoodFiltersBottomSheet({
    super.key,
    required this.presenter,
    required this.viewModel,
  });

  @override
  State<ExternalFoodFiltersBottomSheet> createState() =>
      ExternalFoodFiltersBottomSheetState();
}

class ExternalFoodFiltersBottomSheetState
    extends State<ExternalFoodFiltersBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: SizedBox(
              width: double.infinity,
              child: GcText(
                text: R.string.filterByLabel,
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h3,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount:
                  widget.viewModel.externalFoodFilter.externalFilterType.length,
              itemBuilder: (context, index) {
                final type = widget
                    .viewModel.externalFoodFilter.externalFilterType[index];
                final items =
                    widget.viewModel.externalFoodFilter.filterGroupByType(type);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: GcText(
                        text: type.title.toUpperCase(),
                        textStyleEnum: GcTextStyleEnum.bold,
                        textSize: GcTextSizeEnum.h3,
                        color: AppColors.black,
                        gcStyles: GcStyles.poppins,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: items.map((item) {
                            return IntrinsicWidth(
                              child: FilterCostum(
                                text: item.description,
                                backgroundColor: !item.isSelected
                                    ? AppColors.neutralLight
                                    : AppColors.primaryLight,
                                textColor: item.isSelected
                                    ? AppColors.white
                                    : AppColors.primaryLight,
                                onTap: () {
                                  widget.viewModel =
                                      widget.presenter.setCurrentFilter(
                                    widget.viewModel.externalFoodFilter,
                                    widget.viewModel,
                                    !item.isSelected,
                                    items.indexOf(item),
                                    type,
                                    false,
                                  );
                                  setState(() {});
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
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
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: GcText(
                        text:
                            'Apply (${widget.viewModel.externalFoodFilter.activeFilterGroup.length})',
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
