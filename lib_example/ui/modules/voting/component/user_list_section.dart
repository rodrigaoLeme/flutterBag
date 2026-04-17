import 'package:flutter/material.dart';

import '../voting_view_model.dart';
import 'user_list_cell.dart';

class UserListSection extends StatelessWidget {
  final List<VotingViewModel>? viewModel;
  const UserListSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final item = viewModel?[index];
        return UserListCell(
          viewModel: item,
        );
      },
    );
  }
}
