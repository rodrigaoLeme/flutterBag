import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../main/i18n/app_i18n.dart';

class AuthForgotPasswordSuccessView extends StatelessWidget {
  const AuthForgotPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            appStrings.forgotPasswordSuccessTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            appStrings.forgotPasswordSuccessDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => Modular.to.pop(),
            child: Text(appStrings.forgotPasswordBackToLoginAction),
          ),
        ],
      ),
    );
  }
}
