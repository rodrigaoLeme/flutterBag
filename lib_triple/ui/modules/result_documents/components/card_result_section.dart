import 'package:flutter/widgets.dart';

import '../../../../presentation/presenters/result_documents/result_documents_view_model.dart';
import 'card_result_cell.dart';

class CardResultSection extends StatelessWidget {
  final ResultDocumentsViewModel? viewModel;

  const CardResultSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final data = viewModel?.students ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final resultViewModel = data[index];
        return ResultCardCell(
          viewModel: resultViewModel,
        );
      },
    );
  }
}
