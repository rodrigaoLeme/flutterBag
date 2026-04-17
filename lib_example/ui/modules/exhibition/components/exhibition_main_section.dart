import 'package:flutter/material.dart';

import '../../modules.dart';
import 'exhibition_main_cell.dart';

class ExhibitionMainSection extends StatelessWidget {
  final List<ExhibitionViewModel> exhibitions;
  final Future<ExhibitionViewModel> Function(ExhibitionViewModel)
      onFavoriteToggle;
  final Function(FilesViewModel?) onTapDownload;

  const ExhibitionMainSection({
    super.key,
    required this.exhibitions,
    required this.onFavoriteToggle,
    required this.onTapDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: exhibitions.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ExhibitionMainCell(
            viewModel: exhibitions[index],
            onFavoriteToggle: onFavoriteToggle,
            onTapDownload: onTapDownload,
          ),
        );
      },
    );
  }
}
