import 'package:flutter/material.dart';

import '../notification_view_model.dart';
import 'notification_cell.dart';

class NotificationSection extends StatelessWidget {
  final NotificationViewModel? viewModel;
  final Function(NotificationResultViewModel) onTap;

  const NotificationSection({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: viewModel?.notification?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = viewModel?.notification?[index];
        if (item == null) return const SizedBox();
        return NotificationCell(
          viewModel: item,
          onTap: onTap,
        );
      },
    );
  }
}
