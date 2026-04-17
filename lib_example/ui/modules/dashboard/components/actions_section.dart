import 'package:flutter/material.dart';

import '../section_view_model.dart';
import 'actions_cell.dart';

class ActionSection extends StatelessWidget {
  final List<SectionType> sections;
  final void Function(SectionType) onTap;

  const ActionSection({
    super.key,
    required this.sections,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          sections.length,
          (index) {
            final section = sections[index];

            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 4,
                right: index == sections.length - 1 ? 16 : 4,
              ),
              child: ActionsCell(
                width: index == 0 ? 180.0 : 130.0,
                onTap: onTap,
                type: section,
              ),
            );
          },
        ),
      ),
    );
  }
}
