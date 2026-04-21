import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'forgot_password_presenter.dart';

class ForgotPasswordPage extends StatefulWidget {
  final ForgotPasswordPresenter presenter;

  const ForgotPasswordPage({super.key, required this.presenter});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with NavigationManager {
  final _identifierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToStream);
    widget.presenter.isSuccessStream.listen((success) {
      if (success == true) {
        setState(() => _showSuccess = true);
      }
    });
  }

  bool _showSuccess = false;

  @override
  void dispose() {
    _identifierController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: _showSuccess ? _buildSuccess(context) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return StreamBuilder<LoadingData?>(
        stream: widget.presenter.isLoadingStream,
        builder: (context, loadingSnapshot) {
          final isLoading = loadingSnapshot.data?.isLoading ?? false;
          return StreamBuilder<String?>(
            stream: widget.presenter.uiErrorStream,
            builder: (context, errorSnapshot) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Informe o CPF cadastrado na sua conta.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (errorSnapshot.data != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorSnapshot.data!,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    TextField(
                      controller: _identifierController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                        hintText: '000.000.000-00',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        widget.presenter.forgotPassword(
                          identifier: _identifierController.text,
                        );
                      },
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget _buildSuccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mark_email_read_outlined,
              size: 64, color: Colors.green),
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
}
