import 'package:flutter/material.dart';

import '../voting_view_model.dart';
import 'user_voting_cell.dart';

class UserVotingSection extends StatelessWidget {
  final VotingsViewModel? viewModel;
  final Function(VotingViewModel) onTap;

  const UserVotingSection({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel == null || viewModel!.votings.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 174,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: viewModel!.votings.length,
        itemBuilder: (context, index) {
          final item = viewModel!.votings[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTap(item),
              child: UserVotingCell(viewModel: item),
            ),
          );
        },
      ),
    );
  }
}
