import 'package:flutter/material.dart';

import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
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

  @override
  void dispose() {
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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    appStrings.forgotPasswordHeader,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 28),
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 32),
                  EbolsaLoadingButton(
                    onPressed: _onSubmit,
                    label: appStrings.forgotPasswordConfirmAction,
                    isLoading: vm.isLoading,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
