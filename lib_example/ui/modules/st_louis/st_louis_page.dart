import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../modules.dart';

class StLouisPage extends StatelessWidget {
  final StLouisPresenter presenter;

  const StLouisPage({
    super.key,
    required this.presenter,
  });

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
            text: 'St. Louis & Tourism',
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.bookmark_border,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Search(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 40,
                child: FilterStLouisSection(),
              ),
            ),
            Expanded(
              child: TourismInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
