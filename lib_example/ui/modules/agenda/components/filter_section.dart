import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../modules.dart';

// ignore: must_be_immutable
class FilterSection extends StatelessWidget {
  List<String> filter = ['ALL', 'MON', 'TUE', 'SAT'];

  FilterSection({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filter.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilterCell(
            color:
                index == 0 ? AppColors.primaryLight : AppColors.secondaryFixed,
            title: filter[index],
          ),
        );
      },
    );
  }
}
