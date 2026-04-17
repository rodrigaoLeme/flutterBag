import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.neutralHigh,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.neutralLowMedium,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
