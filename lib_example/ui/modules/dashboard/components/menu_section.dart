import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import './components.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return MenuCell(
          title: '',
          iconPath:
              'lib/ui/assets/images/icon/comments-question-check-light.svg',
          iconColor: AppColors.primaryLight,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: AppColors.primaryLight,
          ),
        );
      },
    );
  }
}
