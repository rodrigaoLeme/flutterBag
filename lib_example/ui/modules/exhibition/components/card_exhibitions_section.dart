import 'package:flutter/material.dart';

import '../exhibition_view_model.dart';
import 'card_exhibitions_cell.dart';

class CardExhibitionsSection extends StatelessWidget {
  final List<FilesViewModel>? files;
  final Function(FilesViewModel?) onTapDownload;

  const CardExhibitionsSection({
    required this.files,
    required this.onTapDownload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: files?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: CardExhibitionsCell(
            file: files?[index],
            onTapDownload: onTapDownload,
          ),
        );
      },
    );
  }
}
