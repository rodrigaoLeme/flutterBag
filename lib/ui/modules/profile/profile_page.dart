import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'profile_presenter.dart';

class ProfilePage extends StatefulWidget {
  final ProfilePresenter? presenter;

  const ProfilePage({super.key, this.presenter});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _fullCpf = '123.456.789-10';
  late final TextEditingController _cpfController;
  final _nameController = TextEditingController(text: 'Ana Julia da Silva');
  final _emailController = TextEditingController(text: 'ana@email.com');
  final _phoneController = TextEditingController(text: '19 9999-8888');

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    widget.presenter?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController(text: _maskCpf(_fullCpf));
  }

  String _maskCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return cpf;
    final g1 = '***';
    final g2 = digits.substring(3, 6);
    final g3 = digits.substring(6, 9);
    final g4 = '**';
    return '$g1.$g2.$g3-$g4';
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Meus dados',
              style: AppTextStyles.titleLarge,
              selectionColor: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 8),
            Text(
              'Confira suas informações de contato e identificação.',
              style: AppTextStyles.bodyMedium,
              selectionColor: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            EbolsaCpfField(
              controller: _cpfController,
              enabled: false,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 16),
            EbolsaTextField(
              controller: _nameController,
              label: 'Nome',
              enabled: false,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 16),
            EbolsaTextField(
              controller: _emailController,
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 16),
            EbolsaTextField(
              controller: _phoneController,
              label: 'Telefone',
              keyboardType: TextInputType.phone,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 20),
            EbolsaButton(
              onPressed: () {},
              label: 'Salvar alterações',
              isSecondary: true,
            ),
            const SizedBox(height: 32),
            Text(
              'Alterar senha',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Mantenha sua conta segura. Se precisar, você pode criar uma nova senha de acesso clicando abaixo.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            EbolsaTextField(
              controller: _currentPasswordController,
              label: appStrings.authPasswordLabel,
              obscureText: _obscurePassword,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
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
            const SizedBox(height: 12),
            EbolsaTextField(
              controller: _newPasswordController,
              label: 'Nova senha',
              obscureText: true,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 12),
            EbolsaTextField(
              controller: _confirmPasswordController,
              label: 'Confirme nova senha',
              obscureText: true,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 20),
            EbolsaButton(
              onPressed: () {},
              label: 'Alterar senha',
              isSecondary: true,
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
