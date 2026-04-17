import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import 'menu_page.dart';

class ModalFood extends StatefulWidget {
  const ModalFood({super.key});

  @override
  ModalFoodState createState() => ModalFoodState();
}

class ModalFoodState extends State<ModalFood> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 765,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                color: AppColors.primaryLight,
              ),
            ),
            Container(
              color: AppColors.white,
              child: TabBar(
                indicatorColor: AppColors.primaryLight,
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.outlineVariant,
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
                          TextSpan(text: R.string.menuLabel),
                          WidgetSpan(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
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
                          TextSpan(text: R.string.restaurantsLabel),
                          WidgetSpan(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onTap: _onItemTapped,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: MenuPage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GcText(
                                text: R.string.favoriteRestaurantLabel,
                                textStyleEnum: GcTextStyleEnum.bold,
                                textSize: GcTextSizeEnum.h3,
                                color: AppColors.black,
                                gcStyles: GcStyles.poppins,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardLigth,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: GcText(
                                    text: R.string.seeAllButon,
                                    textStyleEnum: GcTextStyleEnum.semibold,
                                    textSize: GcTextSizeEnum.subheadline,
                                    color: AppColors.primaryLight,
                                    gcStyles: GcStyles.poppins,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // const ItemsFoodSection(
                          //   showPlaceInTrunkButton: false,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: GcText(
                  text: R.string.close,
                  textStyleEnum: GcTextStyleEnum.bold,
                  textSize: GcTextSizeEnum.callout,
                  color: AppColors.primaryLight,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
