import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../main/i18n/app_i18n.dart';
import 'ebolsa_text_field.dart';

class EbolsaCpfField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool enabled;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const EbolsaCpfField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<EbolsaCpfField> createState() => _EbolsaCpfFieldState();
}

class _EbolsaCpfFieldState extends State<EbolsaCpfField> {
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return EbolsaTextField(
      controller: widget.controller,
      label: widget.label ?? appStrings.authCpfLabel,
      hint: widget.hint ?? appStrings.authCpfHint,
      keyboardType: TextInputType.number,
      inputFormatters: [_cpfMask],
      enabled: widget.enabled,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
