import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/empty_state.dart';
import '../../../helpers/helpers.dart';
import '../food_view_model.dart';
import 'filter_costum.dart';
import 'internal_food_cell.dart';

class InternalFoodSection extends StatefulWidget {
  final FoodViewModel viewModel;

  const InternalFoodSection({
    super.key,
    required bool showPlaceInTrunkButton,
    required this.viewModel,
  });

  @override
  State<InternalFoodSection> createState() => _InternalFoodSectionState();
}

class _InternalFoodSectionState extends State<InternalFoodSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchPurchaseLink(BuildContext context, String? link) async {
    final rawLink = link?.trim() ?? '';
    if (rawLink.isEmpty) return;

    final fixedLink = rawLink.startsWith('http') ? rawLink : 'https://$rawLink';
    final uri = Uri.parse(fixedLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(R.string.couldNotLink),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (widget.viewModel.internalFood.isNotEmpty) {
          widget.viewModel
              .setCurrentInternalFood(widget.viewModel.internalFood.first);
        }
        if (widget.viewModel.internalFood.isEmpty) {
          return SizedBox(
            height: ResponsiveLayout.of(context).hp(80),
            child: EmptyState(
              icon: 'lib/ui/assets/images/icon/utensils.svg',
              title: R.string.messageEmpty,
            ),
          );
        }
        return ValueListenableBuilder(
          valueListenable: widget.viewModel.currentInternalFood,
          builder: (context, snapshot, _) {
            return Column(
              children: [
                SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.viewModel.internalFood.length,
                      itemBuilder: (BuildContext context, int index) {
                        final itemFilter = widget.viewModel.internalFood[index];
                        final isCurrent = widget.viewModel.currentInternalFood
                                .value?.externalId ==
                            itemFilter.externalId;

                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 16.0 : 6.0, right: 6),
                          child: FilterCostum(
                            text: itemFilter.filterDate.toUpperCase(),
                            icon: null,
                            backgroundColor: isCurrent
                                ? AppColors.primaryLight
                                : AppColors.neutralLight,
                            textColor: isCurrent
                                ? AppColors.white
                                : AppColors.primaryLight,
                            onTap: () {
                              widget.viewModel.setCurrentInternalFood(
                                widget.viewModel.internalFood[index],
                              );
                              _scrollController.jumpTo(0);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: InternalFoodCell(
                    scrollController: _scrollController,
                    viewModel: snapshot,
                    onPurchase: (item) async {
                      await _launchPurchaseLink(context, item?.purchaseLink);
                    },
                  ),
                ),
                const SizedBox(
                  height: 45,
                )
              ],
            );
          },
        );
      },
    );
  }
}
