import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../mixins/mixins.dart';
import 'add_account_presenter.dart';
import 'add_account_view_model.dart';

class AddAccountPage extends StatefulWidget {
  final AddAccountPresenter presenter;

  const AddAccountPage({super.key, required this.presenter});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage>
    with NavigationManager {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
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
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToStream);
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

  void _validate() {
    widget.presenter.validateFields(
      name: _nameController.text,
      email: _emailController.text,
      cpf: _cpfController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Responsável')),
      body: SafeArea(
        child: StreamBuilder<AddAccountViewModel?>(
          stream: widget.presenter.viewModelStream,
          initialData: const AddAccountViewModel.empty(),
          builder: (context, snapshot) {
            final vm = snapshot.data ?? const AddAccountViewModel.empty();
            return StreamBuilder<bool?>(
              stream: widget.presenter.isLoadingStream,
              builder: (context, loadingSnapshot) {
                final isLoading = loadingSnapshot.data ?? false;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Este cadastro deve ser preenchido com os dados do Responsável Legal.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _cpfController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cpfMask],
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'CPF',
                          hintText: '000.000.000-00',
                          errorText: vm.cpfError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        enabled: !isLoading,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'Nome completo',
                          errorText: vm.nameError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'seu@email.com',
                          errorText: vm.emailError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_phoneMask],
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'Celular',
                          hintText: '(00) 00000-0000',
                          errorText: vm.phoneError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        enabled: !isLoading,
                        obscureText: _obscurePassword,
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Mínimo 8 caracteres',
                          errorText: vm.passwordError,
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmController,
                        enabled: !isLoading,
                        obscureText: _obscureConfirm,
                        onChanged: (_) => _validate(),
                        decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          errorText: vm.passwordConfirmationError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: isLoading || !vm.isFormValid
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                widget.presenter.addAccount();
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Avançar'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
