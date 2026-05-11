import 'package:flutter/material.dart';

import '../../../main/di/injection_container.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../share/current_account.dart';
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
  final String _fullCpf = sl<CurrentAccount>().userCpf;
  late final TextEditingController _cpfController;
  final _nameController =
      TextEditingController(text: sl<CurrentAccount>().name);
  final _emailController =
      TextEditingController(text: sl<CurrentAccount>().email);
  final _phoneController =
      TextEditingController(text: sl<CurrentAccount>().mobileNumber);

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
              appStrings.profileMyDataTitle,
              style: AppTextStyles.titleLarge,
              selectionColor: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.profileMyDataSubtitle,
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
              label: appStrings.profileMyDataName,
              enabled: false,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 16),
            EbolsaTextField(
              controller: _emailController,
              label: appStrings.profileMyDataEmail,
              keyboardType: TextInputType.emailAddress,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 16),
            EbolsaPhoneField(
              controller: _phoneController,
              label: appStrings.profileMyDataPhone,
              //errorText: vm.fieldError('phone'),
            ),
            const SizedBox(height: 20),
            EbolsaLoadingButton(
              onPressed: () {},
              label: appStrings.profileMyDataSaveButton,
            ),
            const SizedBox(height: 32),
            Text(
              appStrings.profileChangePasswordTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.profileChangePasswordSubtitle,
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
              label: appStrings.profileChangePasswordNewPassword,
              obscureText: true,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 12),
            EbolsaTextField(
              controller: _confirmPasswordController,
              label: appStrings.profileChangePasswordConfirmNewPassword,
              obscureText: true,
              borderWidth: 1,
              borderColor: AppColors.secondary,
              borderRadius: 16,
            ),
            const SizedBox(height: 20),
            EbolsaButton(
              onPressed: () {},
              label: appStrings.profileChangePasswordButton,
              isSecondary: true,
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
