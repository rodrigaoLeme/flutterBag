import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../choose_event_view_model.dart';
import 'event_main_cell.dart';

class EventMainSection extends StatelessWidget {
  final ChooseEventViewModel? viewModel;
  final void Function(EventViewModel?) onTap;
  const EventMainSection({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel?.result.length,
      itemBuilder: (context, index) {
        final eventViewModel = viewModel?.result[index];
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, right: 16.0),
          child: Container(
            color: AppColors.white,
            child: GestureDetector(
              onTap: () {
                onTap(eventViewModel);
              },
              child: EventMainCell(
                viewModel: eventViewModel,
              ),
            ),
          ),
        );
      },
    );
  }
}
