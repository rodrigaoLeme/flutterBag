import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../main/i18n/app_i18n.dart';
import 'ebolsa_text_field.dart';

class EbolsaPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool enabled;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const EbolsaPhoneField({
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
  State<EbolsaPhoneField> createState() => _EbolsaPhoneFieldState();
}

class _EbolsaPhoneFieldState extends State<EbolsaPhoneField> {
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'\d')},
  );

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return EbolsaTextField(
      controller: widget.controller,
      label: widget.label ?? appStrings.authPhoneLabel,
      hint: widget.hint,
      keyboardType: const TextInputType.numberWithOptions(),
      inputFormatters: [_phoneMask],
      enabled: widget.enabled,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
