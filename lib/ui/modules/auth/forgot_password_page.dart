import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/auth_routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';
import 'components/components.dart';

class ForgotPasswordPage extends StatefulWidget {
  final ForgotPasswordPresenter presenter;

  const ForgotPasswordPage({super.key, required this.presenter});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _identifierController = TextEditingController();
  final appStrings = AppI18n.current;
  late StreamSubscription<ForgotPasswordViewModel?> _viewModelSubscription;

  @override
  void initState() {
    super.initState();

    _viewModelSubscription = widget.presenter.viewModel.listen(
      (vm) {
        if (vm == null) return;
        if (vm.isSuccess && vm.emailMasked != null) {
          _showDialogInfo(vm.emailMasked!);
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModelSubscription.cancel();
    _identifierController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    widget.presenter.forgotPassword(
      ForgotPasswordUsecaseParams(identifier: _identifierController.text),
    );
  }

  void _showDialogInfo(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                appStrings.forgotPasswordDialogTitle,
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
                appStrings.forgotPasswordDialogDescription,
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                email,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.bold),
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
            label: appStrings.forgotPasswordDialogDoneButton,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<ForgotPasswordViewModel?>(
          stream: widget.presenter.viewModel,
          initialData: const ForgotPasswordViewModel.initial(),
          builder: (context, snapshot) {
            final vm = snapshot.data ?? const ForgotPasswordViewModel.initial();

            if (vm.isSuccess) return const AuthForgotPasswordSuccessView();

            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    appStrings.forgotPasswordHeader,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appStrings.forgotPasswordDescription,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 14),
                        if (vm.errorMessage != null)
                          EbolsaErrorBanner(message: vm.errorMessage!),
                        EbolsaCpfField(
                          controller: _identifierController,
                          enabled: !vm.isLoading,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          appStrings.forgotPasswordHelpText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  EbolsaLoadingButton(
                    onPressed: _onSubmit,
                    label: appStrings.forgotPasswordConfirmAction,
                    isLoading: vm.isLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
