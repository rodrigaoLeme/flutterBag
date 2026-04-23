import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';
import 'components/components.dart';
import 'terms_page.dart';

class CreateAccountPage extends StatefulWidget {
  final CreateAccountPresenter presenter;

  const CreateAccountPage({super.key, required this.presenter});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialogInfo();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onSubmit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TermsPage()),
    );

    // FocusScope.of(context).unfocus();
    // widget.presenter.createAccount(
    //   CreateAccountUsecaseParams(
    //     cpf: _cpfController.text,
    //     name: _nameController.text,
    //     email: _emailController.text,
    //     phone: _phoneController.text,
    //     password: _passwordController.text,
    //     passwordConfirmation: _confirmController.text,
    //   ),
    // );
  }

  void _showDialogInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //backgroundColor: AppStyle.backgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Atenção!',
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
                'Este cadastro inicial é exclusivo para o Responsável Legal (requerente); não utilize os dados do candidato/aluno nesta tela.\n\nSe já possui um acesso de anos anteriores, clique em "Entrar" na página inicial, e, se não lembrar a senha, use a opção "Esqueceu sua senha?" na telade Login.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          EbolsaTextButton(
            onPressed: () => Navigator.pop(context),
            label: 'Estou ciente',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(title: Text(appStrings.createAccountPageTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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

                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            appStrings.createAccountHeader,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            appStrings.createAccountDescription,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 32),
                          if (vm.errorMessage != null)
                            EbolsaErrorBanner(message: vm.errorMessage!),
                          EbolsaCpfField(
                            controller: _cpfController,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('cpf'),
                          ),
                          const SizedBox(height: 16),
                          EbolsaTextField(
                            controller: _nameController,
                            label: appStrings.createAccountFullNameLabel,
                            hint: appStrings.createAccountFullNameHint,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('name'),
                          ),
                          const SizedBox(height: 16),
                          EbolsaTextField(
                            controller: _emailController,
                            label: appStrings.authEmailLabel,
                            hint: appStrings.createAccountEmailHint,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('email'),
                          ),
                          const SizedBox(height: 16),
                          EbolsaPhoneField(
                            controller: _phoneController,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('phone'),
                          ),
                          const SizedBox(height: 16),
                          AuthPasswordField(
                            controller: _passwordController,
                            label: appStrings.authPasswordLabel,
                            hint: appStrings.createAccountPasswordHint,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('password'),
                          ),
                          const SizedBox(height: 16),
                          AuthPasswordField(
                            controller: _confirmController,
                            label: appStrings.createAccountConfirmPasswordLabel,
                            hint: appStrings.createAccountConfirmPasswordHint,
                            enabled: !vm.isLoading,
                            errorText: vm.fieldError('passwordConfirmation'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EbolsaButton(
                onPressed: _onSubmit,
                label: appStrings.createAccountNextAction,
                //isLoading: vm.isLoading,
              ),
            )
          ],
        ),
      ),
    );
  }
}
