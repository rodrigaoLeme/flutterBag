import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';
import '../../../auth/components/auth_password_field.dart';

class DeclarationPasswordDialog extends StatefulWidget {
  final Future<String?> Function(String password) onSubmit;

  const DeclarationPasswordDialog({super.key, required this.onSubmit});

  static Future<bool?> show(
    BuildContext context, {
    required Future<String?> Function(String password) onSubmit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => DeclarationPasswordDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<DeclarationPasswordDialog> createState() =>
      _DeclarationPasswordDialogState();
}

class _DeclarationPasswordDialogState extends State<DeclarationPasswordDialog> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _controller.text;
    if (password.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final error = await widget.onSubmit(password);
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isSubmitting = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    return AlertDialog(
      backgroundColor: AppColors.backgroundLight,
      title:
          Text(i18n.declarationPasswordTitle, style: AppTextStyles.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(i18n.declarationPasswordDescription,
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          AuthPasswordField(
            controller: _controller,
            label: i18n.authPasswordLabel,
            enabled: !_isSubmitting,
            errorText: _error,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  i18n.confirmAction,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.primary),
                ),
        ),
      ],
    );
  }
}
