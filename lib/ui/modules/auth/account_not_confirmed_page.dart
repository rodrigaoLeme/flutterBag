import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/auth_routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';

class AccountNotConfirmedPage extends StatefulWidget {
  final AccountNotConfirmedPresenter presenter;

  const AccountNotConfirmedPage({
    super.key,
    required this.presenter,
  });

  @override
  State<AccountNotConfirmedPage> createState() =>
      _AccountNotConfirmedPageState();
}

class _AccountNotConfirmedPageState extends State<AccountNotConfirmedPage> {
  final _emailController = TextEditingController();

  final appStrings = AppI18n.current;

  late StreamSubscription<AuthViewModel?> _viewModelSubscription;

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
  void initState() {
    super.initState();
    _viewModelSubscription = widget.presenter.viewModel.listen(
      (vm) {
        if (vm == null) return;
        if (vm.isValid) {
          widget.presenter.sendEmailVerification(
            SendEmailVerificationParams(userId: _emailController.text.trim()),
          );
        }
        if (vm.isSuccess) {
          _showDialogInfo();
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController;
    _viewModelSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onResendPressed() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    widget.presenter.validateEmail(email);
  }

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
              child: StreamBuilder<AuthViewModel?>(
                stream: widget.presenter.viewModel,
                initialData: const AuthViewModel.initial(),
                builder: (context, snapshot) {
                  final vm = snapshot.data ?? const AuthViewModel.initial();
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
                          errorText: vm.fieldError('email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            StreamBuilder(
                stream: widget.presenter.viewModel,
                initialData: const AuthViewModel.initial(),
                builder: (context, snapshot) {
                  final vm = snapshot.data ?? const AuthViewModel.initial();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: EbolsaLoadingButton(
                      onPressed: vm.isLoading ? null : _onResendPressed,
                      isLoading: vm.isLoading,
                      label: appStrings.accountNotConfirmedResendEmailButton,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
