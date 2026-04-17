import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/helpers.dart';
import '../dashboard/section_view_model.dart';
import 'components/external_food_section.dart';
import 'components/internal_food_section.dart';
import 'food_presenter.dart';
import 'food_view_model.dart';

class FoodPage extends StatefulWidget {
  final FoodPresenter presenter;

  const FoodPage({
    super.key,
    required this.presenter,
  });

  @override
  FoodPageState createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool shouldUpdate = true;

  void _onItemTapped(int index) {
    _tabController.index = index;
    _selectedIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    widget.presenter.fetchExternalFood();
    widget.presenter.fetchInternalFood();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.foodLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<FoodViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/plate-utensils.svg',
              title: R.string.messageEmpty,
            );
          }

          if (shouldUpdate) {
            _tabController.index =
                viewModel.type == SectionType.restaurantsInternal ? 1 : 0;
            _selectedIndex =
                viewModel.type == SectionType.restaurantsInternal ? 1 : 0;
            shouldUpdate = false;
          }
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  color: AppColors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorWeight: 2.0,
                    indicatorColor: AppColors.primaryLight,
                    labelColor: AppColors.black,
                    unselectedLabelColor: AppColors.onSecundaryContainer,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabAlignment: TabAlignment.center,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _selectedIndex == 0
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: _selectedIndex == 0
                                    ? AppColors.primaryLight
                                    : AppColors.black,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                        R.string.localRestaurant.toUpperCase()),
                                WidgetSpan(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _selectedIndex == 1
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: _selectedIndex == 1
                                    ? AppColors.primaryLight
                                    : AppColors.black,
                              ),
                              children: [
                                TextSpan(
                                    text: R.string.diningHall.toUpperCase()),
                                WidgetSpan(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _selectedIndex == 2
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: _selectedIndex == 2
                                    ? AppColors.primaryLight
                                    : AppColors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: R.string.favoritesLabel,
                                ),
                                WidgetSpan(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    onTap: _onItemTapped,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                        ),
                        child: ExternalFoodSection(
                          showPlaceInTrunkButton: false,
                          viewModel: viewModel.externalFoodFiltered,
                          foodViewModel: viewModel,
                          presenter: widget.presenter,
                          onFavoriteToggle: (food) async {
                            return await widget.presenter
                                .saveFavorites(food: food);
                          },
                          isFavorite: false,
                        ),
                      ),
                      InternalFoodSection(
                        showPlaceInTrunkButton: false,
                        viewModel: viewModel,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ExternalFoodSection(
                          showPlaceInTrunkButton: false,
                          viewModel: viewModel.favoreitesExternalFiltered,
                          foodViewModel: viewModel,
                          presenter: widget.presenter,
                          onFavoriteToggle: (food) async {
                            return await widget.presenter
                                .saveFavorites(food: food);
                          },
                          isFavorite: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
