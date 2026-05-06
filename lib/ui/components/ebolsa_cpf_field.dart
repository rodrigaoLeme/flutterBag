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
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  const EbolsaCpfField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
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
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      borderRadius: widget.borderRadius,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
