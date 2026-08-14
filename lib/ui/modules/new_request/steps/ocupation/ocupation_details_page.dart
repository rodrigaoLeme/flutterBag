import 'package:flutter/material.dart';

import '../../../../helpers/themes/themes.dart';
import 'ocupation_details_view_model.dart';

class OccupationDetailsPage extends StatefulWidget {
  const OccupationDetailsPage({
    super.key,
    required this.viewModel,
  });

  final OccupationDetailsViewModel viewModel;

  @override
  State<OccupationDetailsPage> createState() => _OccupationDetailsPageState();
}

class _OccupationDetailsPageState extends State<OccupationDetailsPage> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Widget _buildField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.viewModel.controllers[hint],
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Informação trabalhista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ocupação',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              vm.description,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(vm.title),
            ),
            const SizedBox(height: 24),
            ...vm.fieldHints.map(_buildField),
            _buildField('Recebimento mensal em R\$'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              final saved = await widget.viewModel.save();
              Navigator.pop(context, saved);
            },
            child: const Text('Adicionar ocupação'),
          ),
        ),
      ),
    );
  }
}
