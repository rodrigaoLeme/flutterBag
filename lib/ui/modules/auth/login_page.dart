import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../main/routes/routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );

  @override
  void initState() {
    super.initState();
    _subscribeStreams();
  }

  void _subscribeStreams() {
    widget.presenter.isSessionExpiredStream.listen((_) {
      Modular.to.navigate(Routes.login);
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();
    widget.presenter.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<AuthViewModel?>(
          stream: widget.presenter.viewModel,
          initialData: const AuthViewModel.initial(),
          builder: (context, snapshot) {
            final vm = snapshot.data ?? const AuthViewModel.initial();

            if (vm.isSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                //Modular.to.navigate();
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      'lib/ui/assets/images/logo.png',
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.school, size: 80),
                    ),
                  ),
                  const SizedBox(height: 100),
                  if (vm.errorMessage != null)
                    EbolsaErrorBanner(message: vm.errorMessage!),
                  EbolsaTextField(
                    controller: _identifierController,
                    label: 'CPF',
                    hint: '000.000.000-00',
                    keyboardType: TextInputType.number,
                    inputFormatters: [_cpfMask],
                    enabled: !vm.isLoading,
                  ),
                  const SizedBox(height: 16),
                  EbolsaTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    hint: 'Digite sua senha',
                    obscureText: _obscurePassword,
                    enabled: !vm.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: vm.isLoading
                          ? null
                          : () => Modular.to.pushNamed(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        textStyle: AppTextStyles.labelLarge,
                        foregroundColor: AppColors.textSecondaryLight,
                      ),
                      child: const Text('Esqueceu sua senha?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  EbolsaLoadingButton(
                    onPressed: _onLoginPressed,
                    label: 'Entrar',
                    isLoading: vm.isLoading,
                  ),
                  const SizedBox(height: 16),
                  EbolsaButton(
                    onPressed: () => Modular.to.pushNamed(Routes.addAccount),
                    label: 'Criar conta',
                    isSecondary: true,
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
