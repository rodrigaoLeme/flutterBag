import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../exhibition/exhibition_view_model.dart';
import 'exhibitions_cell.dart';

class ExhibitionsSection extends StatelessWidget {
  final ExhibitionsViewModel? exhibitionViewModel;
  final void Function(ExhibitionViewModel?) onTap;

  const ExhibitionsSection({
    super.key,
    required this.exhibitionViewModel,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final sections = exhibitionViewModel?.homeSections ?? [];

    int maxItemsInColumn = 0;

    for (final section in sections) {
      if (section.length > maxItemsInColumn) {
        maxItemsInColumn = section.length;
      }
    }

    const cardHeight = 88.0;
    final calculatedHeight = maxItemsInColumn * cardHeight;

    return SizedBox(
      height: calculatedHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final homeSectionsLength =
              exhibitionViewModel?.homeSections.length ?? 0;
          final hasOnlyOneItem = homeSectionsLength == 1;
          final isLastItem = index == (homeSectionsLength - 1);
          final isFirst = !hasOnlyOneItem && (homeSectionsLength > 1);
          final viewModel = exhibitionViewModel?.homeSections[index];
          final right = hasOnlyOneItem || isFirst ? 16.0 : 0.0;
          final layout = ResponsiveLayout.of(context);

          return Padding(
            padding: EdgeInsets.only(
              top: 8,
              left: (hasOnlyOneItem || !isLastItem) ? 16 : 0,
              right: right,
            ),
            child: ExhibitionsCell(
              width: hasOnlyOneItem ? layout.width - 32 : layout.width - 64,
              exhibitions: viewModel ?? [],
              onTap: onTap,
            ),
          );
        },
      ),
    );
  }
}
