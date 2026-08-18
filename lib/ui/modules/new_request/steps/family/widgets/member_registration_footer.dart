import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/ebolsa_button.dart';
import '../../../../../helpers/themes/themes.dart';

class MemberRegistrationFooter extends StatelessWidget {
  const MemberRegistrationFooter({
    super.key,
    required this.canAdvance,
    required this.onBack,
    required this.onAdvance,
    this.showBack = true,
    this.advanceLabel,
  });

  final bool canAdvance;
  final VoidCallback onBack;
  final VoidCallback onAdvance;
  final bool showBack;
  final String? advanceLabel;

  @override
  Widget build(BuildContext context) {
    final nextLabel =
        advanceLabel ?? AppI18n.current.createAccountNextAction;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFB9BDC6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Voltar',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: EbolsaButton(
              onPressed: canAdvance ? onAdvance : null,
              label: nextLabel,
            ),
          ),
        ],
      ),
    );
  }
}
