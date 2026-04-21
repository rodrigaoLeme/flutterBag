import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../main/routes/routes.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import '../../mixins/mixins.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with NavigationManager, SessionManager {
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
    handleNavigation(widget.presenter.navigateToStream);
    handleSessionExpired(widget.presenter.isSessionExpiredStream);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();
    widget.presenter.auth(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<LoadingData?>(
            stream: widget.presenter.isLoadingStream,
            builder: (context, loadingSnapshot) {
              final isLoading = loadingSnapshot.data?.isLoading ?? false;
              return StreamBuilder<String?>(
                stream: widget.presenter.uiErrorStream,
                builder: (context, errorSnapshot) {
                  final error = errorSnapshot.data;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: Text('LOGO AQUI'),
                        ),
                        const SizedBox(height: 32),
                        if (error != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              error,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ),
                        TextField(
                          controller: _identifierController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_cpfMask],
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            hintText: '000.000.000-00',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () =>
                                Modular.to.pushNamed(Routes.forgotPassword),
                            child: Text(
                              'Esqueceu sua senha?',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        EbolsaLoadingButton(
                          onPressed: _onLogin,
                          label: 'Entrar',
                        ),
                        const SizedBox(height: 16),
                        EbolsaButton(
                          onPressed: () =>
                              Modular.to.pushNamed(Routes.addAccount),
                          label: 'Criar Conta',
                          isSecondary: true,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
