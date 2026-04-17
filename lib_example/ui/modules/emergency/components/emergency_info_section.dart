import 'package:flutter/material.dart';

import '../emergency_view_model.dart';
import 'emergency_info_cell.dart';

class EmergencyInfoSection extends StatelessWidget {
  final EmergencyViewModel viewModel;

  const EmergencyInfoSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.result?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final emergencyResult = viewModel.result?[index];
          return EmergencyInfoCell(viewModel: emergencyResult);
        },
      ),
    );
  }
}
