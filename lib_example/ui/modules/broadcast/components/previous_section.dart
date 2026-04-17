import 'package:flutter/material.dart';

import '../broadcast_view_model.dart';
import 'previous_cell.dart';

class PreviousSection extends StatefulWidget {
  final List<BroadcastViewModel>? viewModel;
  final Function(BroadcastViewModel?) onTap;

  const PreviousSection({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  State<PreviousSection> createState() => _PreviousSectionState();
}

class _PreviousSectionState extends State<PreviousSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.viewModel?.length ?? 0,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.viewModel?[index];

        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: PreviousCell(
            viewModel: item,
            onTap: widget.onTap,
          ),
        );
      },
    );
  }
}
