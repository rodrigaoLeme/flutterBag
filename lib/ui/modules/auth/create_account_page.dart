import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../components/components.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );

  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'\d')},
  );

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
    FocusScope.of(context).unfocus();
    widget.presenter.createAccount(
      cpf: _cpfController.text,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
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

            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Cadastro Responsável',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Este cadastro deve ser preenchido com os dados do Responsável Legal.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    if (vm.errorMessage != null)
                      EbolsaErrorBanner(message: vm.errorMessage!),
                    EbolsaTextField(
                      controller: _cpfController,
                      label: 'CPF',
                      hint: '000.000.000-00',
                      keyboardType: TextInputType.number,
                      inputFormatters: [_cpfMask],
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('cpf'),
                    ),
                    const SizedBox(height: 16),
                    EbolsaTextField(
                      controller: _nameController,
                      label: 'Nome completo',
                      hint: 'Como consta no documento',
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('name'),
                    ),
                    const SizedBox(height: 16),
                    EbolsaTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      hint: 'seu@email.com',
                      keyboardType: TextInputType.emailAddress,
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('email'),
                    ),
                    const SizedBox(height: 16),
                    EbolsaTextField(
                      controller: _phoneController,
                      label: 'Celular',
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [_phoneMask],
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('phone'),
                    ),
                    const SizedBox(height: 16),
                    EbolsaTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      hint: 'Mínimo 8 caracteres',
                      obscureText: _obscurePassword,
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('password'),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 16),
                    EbolsaTextField(
                      controller: _confirmController,
                      label: 'Confirmar senha',
                      hint: 'Repita sua senha',
                      obscureText: _obscureConfirm,
                      enabled: !vm.isLoading,
                      errorText: vm.fieldError('passwordConfirmation'),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    Spacer(),
                    EbolsaLoadingButton(
                      onPressed: _onSubmit,
                      label: 'Avançar',
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
