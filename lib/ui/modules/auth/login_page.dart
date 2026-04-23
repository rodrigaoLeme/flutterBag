import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/auth_routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';
import 'components/components.dart';

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
  late StreamSubscription<bool> _sessionExpiredSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeStreams();
  }

  void _subscribeStreams() {
    _sessionExpiredSubscription =
        widget.presenter.isSessionExpiredStream.listen((_) {
      Modular.to.navigate(AuthRoutes.login);
    });
  }

  @override
  void dispose() {
    _sessionExpiredSubscription.cancel();
    _identifierController.dispose();
    _passwordController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();
    widget.presenter.login(
      LoginUsecaseParams(
        identifier: _identifierController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

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
                  const AuthLoginLogo(),
                  const SizedBox(height: 100),
                  if (vm.errorMessage != null)
                    EbolsaErrorBanner(message: vm.errorMessage!),
                  EbolsaCpfField(
                    controller: _identifierController,
                    enabled: !vm.isLoading,
                  ),
                  const SizedBox(height: 16),
                  EbolsaTextField(
                    controller: _passwordController,
                    label: appStrings.authPasswordLabel,
                    hint: appStrings.loginPasswordHint,
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
                          : () =>
                              Modular.to.pushNamed(AuthRoutes.forgotPassword),
                      style: TextButton.styleFrom(
                        textStyle: AppTextStyles.labelLarge,
                        foregroundColor: AppColors.textSecondaryLight,
                      ),
                      child: Text(appStrings.authForgotPasswordAction),
                    ),
                  ),
                  const SizedBox(height: 24),
                  EbolsaLoadingButton(
                    onPressed: _onLoginPressed,
                    label: appStrings.authLoginAction,
                    isLoading: vm.isLoading,
                  ),
                  const SizedBox(height: 16),
                  EbolsaButton(
                    onPressed: () =>
                        Modular.to.pushNamed(AuthRoutes.createAccount),
                    label: appStrings.authCreateAccountAction,
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
