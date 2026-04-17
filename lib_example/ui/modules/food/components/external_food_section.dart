import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/empty_state.dart';
import '../../../helpers/i18n/resources.dart';
import '../food_presenter.dart';
import '../food_view_model.dart';
import 'external_food_cell.dart';
import 'external_food_filters_bottom_sheet.dart';
import 'filter_costum.dart';
import 'food_details_bottom_sheet.dart';

// ignore: must_be_immutable
class ExternalFoodSection extends StatefulWidget {
  final List<ExternalFoodViewModel> viewModel;
  final FoodViewModel foodViewModel;
  ValueNotifier<FoodViewModel?> foodViewModelListener = ValueNotifier(null);
  final Future<ExternalFoodViewModel> Function(ExternalFoodViewModel)
      onFavoriteToggle;
  final bool isFavorite;
  final FoodPresenter presenter;

  ExternalFoodSection({
    super.key,
    required bool showPlaceInTrunkButton,
    required this.viewModel,
    required this.onFavoriteToggle,
    required this.foodViewModel,
    required this.isFavorite,
    required this.presenter,
  });

  @override
  State<ExternalFoodSection> createState() => _ExternalFoodSectionState();
}

class _ExternalFoodSectionState extends State<ExternalFoodSection> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        widget.foodViewModelListener.value = widget.foodViewModel;
        return ValueListenableBuilder(
          valueListenable: widget.foodViewModelListener,
          builder: (context, snapshot, _) {
            final currentFoodViewModel = snapshot;
            if (currentFoodViewModel == null ||
                currentFoodViewModel.externalFood.isEmpty) {
              return EmptyState(
                icon: 'lib/ui/assets/images/icon/plate-utensils.svg',
                title: R.string.messageEmpty,
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: currentFoodViewModel
                            .externalFoodFilter.activeFilterGroup.length +
                        1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: FilterCostum(
                            text: R.string.filtersLabel,
                            customIcon: SvgPicture.asset(
                              'lib/ui/assets/images/icon/filter-list-regular.svg',
                              height: 16,
                              width: 16,
                              color: AppColors.white,
                            ),
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.white,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ExternalFoodFiltersBottomSheet(
                                  presenter: widget.presenter,
                                  viewModel: currentFoodViewModel,
                                ),
                              );
                            },
                          ),
                        );
                      }
                      final safeIndex = index - 1;

                      final group = currentFoodViewModel
                          .externalFoodFilter.activeFilterGroup[safeIndex];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: currentFoodViewModel.externalFoodFilter
                                      .activeFilterGroup.length ==
                                  index
                              ? 16
                              : 0,
                        ),
                        child: FilterCostum(
                          icon: Icons.close,
                          text: group.description,
                          backgroundColor: !group.isSelected
                              ? AppColors.neutralLight
                              : AppColors.primaryLight,
                          textColor: group.isSelected
                              ? AppColors.white
                              : AppColors.primaryLight,
                          onTap: () {
                            final items = currentFoodViewModel
                                .externalFoodFilter
                                .filterGroupByType(group.type);
                            widget.foodViewModelListener.value =
                                widget.presenter.setCurrentFilter(
                                    currentFoodViewModel.externalFoodFilter,
                                    currentFoodViewModel,
                                    false,
                                    items.indexOf(group),
                                    group.type,
                                    widget.isFavorite);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: widget.viewModel.isEmpty == true
                      ? EmptyState(
                          icon: 'lib/ui/assets/images/icon/plate-utensils.svg',
                          title: R.string.messageEmpty,
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.viewModel.length,
                            itemBuilder: (BuildContext context, int index) {
                              final externalFoodViewModel =
                                  widget.viewModel[index];
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return FoodDetailsBottomSheet(
                                        viewModel: externalFoodViewModel,
                                        onFavoriteToggle:
                                            widget.onFavoriteToggle,
                                      );
                                    },
                                  );
                                },
                                child: ExternalFoodCell(
                                  viewModel: externalFoodViewModel,
                                  onFavoriteToggle: widget.onFavoriteToggle,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
