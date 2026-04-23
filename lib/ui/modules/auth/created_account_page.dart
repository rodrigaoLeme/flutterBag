import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/ebolsa_button.dart';
import '../../helpers/themes/themes.dart';

class CreatedAccountPage extends StatelessWidget {
  CreatedAccountPage({super.key});

  final MarkdownBody _accountSuccessDescription = MarkdownBody(
    data: AppI18n.current.createdAccountSuccessDescription,
    styleSheet: MarkdownStyleSheet(
      strong: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                appStrings.createdAccountPageTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 175,
              ),
              Text('Imagem'),
              SizedBox(
                height: 175,
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                appStrings.createdAccountSuccessTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 22,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _accountSuccessDescription,
              Spacer(),
              EbolsaButton(
                onPressed: () {},
                label: appStrings.createdAccountDoneButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
