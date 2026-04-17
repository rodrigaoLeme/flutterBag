import 'package:flutter/material.dart';

import '../section_view_model.dart';
import 'restaurant_card_cell.dart';

class RestaurantCardSection extends StatelessWidget {
  final List<SectionType> sections;
  final void Function(SectionType) onTap;

  const RestaurantCardSection({
    super.key,
    required this.sections,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        sections.length,
        (index) {
          final section = sections[index];

          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: RestaurantCardCell(
              type: section,
              onTap: onTap,
            ),
          );
        },
      ),
    );
  }
}
