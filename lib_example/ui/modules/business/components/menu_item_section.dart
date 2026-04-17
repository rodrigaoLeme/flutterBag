import 'package:flutter/material.dart';

import '../../dashboard/section_view_model.dart';
import 'menu_item_cell.dart';

class MenuItemSection extends StatelessWidget {
  final List<SectionType> sections;
  final void Function(SectionType) onTap;

  const MenuItemSection({
    super.key,
    required this.sections,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(sections.length, (index) {
          final section = sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MenuItemCell(
              onTap: onTap,
              type: section,
            ),
          );
        }),
      ),
    );
  }
}
