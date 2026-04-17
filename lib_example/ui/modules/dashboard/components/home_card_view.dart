import 'package:flutter/material.dart';

import '../../modules.dart';
import 'schedule_cell.dart';

class HomeCardView extends StatelessWidget {
  final DashboardPresenter presenter;
  final AgendaViewModel? viewModel;
  final void Function(int) onPressed;
  final ConnectionState connectionState;
  final Function(ScheduleViewModel?) goToDetails;

  const HomeCardView({
    super.key,
    required this.presenter,
    required this.viewModel,
    required this.onPressed,
    required this.connectionState,
    required this.goToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel?.tabs.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final data = viewModel?.tabs[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 0,
            right: viewModel?.tabs.length == 1 ? 0.0 : 16.0,
            bottom: 4.0,
          ),
          child: ScheduleCell(
            onPressed: () {
              onPressed(index);
            },
            viewModel: data,
            percent: 0.80,
            connectionState: connectionState,
            goToDetails: goToDetails,
          ),
        );
      },
    );
  }
}
