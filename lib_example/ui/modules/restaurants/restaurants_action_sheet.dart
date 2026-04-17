import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../helpers/i18n/resources.dart';
import '../modules.dart';

class RestaurantActionSheet {
  static void show(
    BuildContext context,
    Function()? onPressed,
  ) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.close),
                TabBar(
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.onSecundaryContainer,
                  tabs: [
                    Tab(text: R.string.ticketLabel),
                    Tab(text: R.string.menuLabel),
                    Tab(text: R.string.foodLabel),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      Ticket(),
                      Menu(),
                      Restaurant(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
