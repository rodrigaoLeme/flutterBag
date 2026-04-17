import 'package:flutter/material.dart';

import '../../modules.dart';
import 'ministries_cell.dart';

class MinistriesSection extends StatelessWidget {
  final VotingsViewModel? viewModel;
  final void Function(DivisionGroup?) onChanged;

  const MinistriesSection({
    super.key,
    required this.viewModel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final divisionGroups = viewModel?.divisionGroupsFiltered ?? [];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 4,
        scrollDirection: Axis.vertical,
        childAspectRatio: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        children: divisionGroups.map((item) {
          return MinistriesCell(
            viewModel: item,
            onChanged: onChanged,
          );
        }).toList(),
      ),
    );
  }
}
