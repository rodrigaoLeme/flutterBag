import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/auth_routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';

class AccountNotConfirmedPage extends StatefulWidget {
  const AccountNotConfirmedPage({super.key});

  @override
  State<AccountNotConfirmedPage> createState() =>
      _AccountNotConfirmedPageState();
}

class _AccountNotConfirmedPageState extends State<AccountNotConfirmedPage> {
  final _emailController = TextEditingController();

  final appStrings = AppI18n.current;

  final MarkdownBody _accountNotConfirmedDescription = MarkdownBody(
    data: AppI18n.current.accountNotConfirmedDescription,
    styleSheet: MarkdownStyleSheet(
      textAlign: WrapAlignment.center,
      p: AppTextStyles.bodyMedium.copyWith(
        fontSize: 17,
      ),
      strong: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),
  );

  @override
  void dispose() {
    _emailController;
    super.dispose();
  }

  void _onResendPressed() {}

  void _showDialogInfo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                appStrings.accountNotConfirmedDialogTitle,
                style: AppTextStyles.titleLarge,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appStrings.accountNotConfirmedDialogDescription,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          EbolsaTextButton(
            onPressed: () {
              Navigator.pop(context);
              Modular.to.navigate(AuthRoutes.login);
            },
            label: appStrings.accountNotConfirmedDialogDoneButton,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        SvgPicture.asset(
                          'lib/ui/assets/images/account-not-confirmed.svg',
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          appStrings.accountNotConfirmedTitle,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 22,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _accountNotConfirmedDescription,
                        SizedBox(
                          height: 24,
                        ),
                        EbolsaTextField(
                          controller: _emailController,
                          label: appStrings.authEmailLabel,
                          hint: appStrings.authEmailLabel,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EbolsaButton(
                onPressed: () => _showDialogInfo(),
                label: appStrings.accountNotConfirmedResendEmailButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
