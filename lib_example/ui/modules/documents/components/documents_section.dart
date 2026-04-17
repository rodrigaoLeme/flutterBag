import 'package:flutter/material.dart';

import '../documents_presenter.dart';
import '../documents_view_model.dart';
import 'documents_cell.dart';
import 'documents_details.dart';

class DocumentsSection extends StatelessWidget {
  final DocumentsViewModel viewModel;
  final DocumentsPresenter presenter;

  const DocumentsSection({
    super.key,
    required this.viewModel,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.docFiltered?.length,
      itemBuilder: (BuildContext context, int index) {
        final item = viewModel.docFiltered?[index];
        if (item == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              DocumentsCell(
                viewModel: item,
                onTap: (documentsViewModel) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentsDetails(
                        viewModel: documentsViewModel,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
