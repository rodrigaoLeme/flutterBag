import 'package:flutter/material.dart';

import '../translation_view_model.dart';
import 'translation_cell.dart';

class TranslationSection extends StatefulWidget {
  final TranslationViewModel? viewModel;
  final void Function(Languages?) onTap;

  const TranslationSection({
    required this.viewModel,
    required this.onTap,
    super.key,
  });

  @override
  State<TranslationSection> createState() => _TranslationSectionState();
}

class _TranslationSectionState extends State<TranslationSection> {
  Languages? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.viewModel?.languages.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.viewModel?.languages[index];
          return TranslationCell(
            language: item,
            isSelected: item?.contryName == selectedLanguage?.contryName,
            onTap: (language) {
              widget.onTap(language);
              setState(() {
                selectedLanguage = language;
              });
            },
          );
        },
      ),
    );
  }
}
