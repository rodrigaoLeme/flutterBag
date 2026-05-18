import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../helpers/themes/app_text_styles.dart';

class EbolsaTypeAheadField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String>? suggestions;
  final FutureOr<List<String>> Function(String)? suggestionsCallback;
  final void Function(String)? onSuggestionSelected;
  final void Function(String)? onChanged;

  const EbolsaTypeAheadField({
    super.key,
    required this.controller,
    required this.label,
    this.suggestions,
    this.suggestionsCallback,
    this.onSuggestionSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: AppTextStyles.bodyMedium,
        onChanged: onChanged,
      ),
      suggestionsCallback: suggestionsCallback ??
          (pattern) async {
            final list = suggestions ?? <String>[];
            if (pattern.trim().isEmpty) return list;
            return list
                .where((s) =>
                    s.toLowerCase().contains(pattern.trim().toLowerCase()))
                .toList();
          },
      itemBuilder: (context, String suggestion) => ListTile(
        title: Text(suggestion, style: AppTextStyles.bodyMedium),
      ),
      onSuggestionSelected: (String suggestion) {
        controller.text = suggestion;
        if (onSuggestionSelected != null) onSuggestionSelected!(suggestion);
      },
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Text('Nenhuma opção encontrada', style: AppTextStyles.bodyMedium),
      ),
    );
  }
}
