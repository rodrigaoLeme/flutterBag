import 'package:flutter/material.dart';

import '../../modules.dart';
import '../support_presenter.dart';
import 'support_details.dart';

class FaqInformationSection extends StatelessWidget {
  final SupportViewModel viewModel;
  final SupportPresenter presenter;

  const FaqInformationSection({
    super.key,
    required this.viewModel,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.supportFiltered?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final item = viewModel.supportFiltered?[index];
        if (item == null) return const SizedBox.shrink();
        return Column(
          children: [
            FaqInformationCell(
              viewModel: item,
              onTap: (supportViewModel) {
                showSupportModal(context, supportViewModel);
              },
            ),
          ],
        );
      },
    );
  }
}
