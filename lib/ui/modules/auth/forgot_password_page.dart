import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../components/components.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';

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
    widget.presenter.forgotPassword(identifier: _identifierController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<ForgotPasswordViewModel?>(
          stream: widget.presenter.viewModel,
          initialData: const ForgotPasswordViewModel.initial(),
          builder: (context, snapshot) {
            final vm = snapshot.data ?? const ForgotPasswordViewModel.initial();

            if (vm.isSuccess) {
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
                      'E-mail enviado!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () => Modular.to.pop(),
                      child: const Text('Voltar para o login'),
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Redefinir Senha',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Insira seu CPF para redefinir sua senha:',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    if (vm.errorMessage != null)
                      EbolsaErrorBanner(message: vm.errorMessage!),
                    EbolsaTextField(
                      controller: _identifierController,
                      label: 'CPF',
                      hint: '000.000.000-00',
                      keyboardType: TextInputType.number,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Enviaremos um  link para o e-mail cadastrado neste CPF para que você possa redefinir sua senha. Esse link irá expirar em três horas.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Color(0xFF1D1B20),
                      ),
                    ),
                    Spacer(),
                    EbolsaLoadingButton(
                      onPressed: _onSubmit,
                      label: 'Confirmar',
                      isLoading: vm.isLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
