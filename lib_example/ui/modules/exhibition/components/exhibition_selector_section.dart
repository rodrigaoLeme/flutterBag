import 'package:flutter/material.dart';

import '../../modules.dart';
import 'exhibition_selector_cell.dart';

class ExhibitionSelectorSection extends StatelessWidget {
  final List<ExhibitionGroup> exhibitionGroups;
  final void Function(ExhibitionGroup?) onChanged;

  const ExhibitionSelectorSection({
    super.key,
    required this.exhibitionGroups,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        childAspectRatio: 2.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        children: exhibitionGroups.map((item) {
          return ExhibitionSelectorCell(
            viewModel: item,
            onChanged: onChanged,
          );
        }).toList(),
      ),
    );
  }
}
