import 'dart:async';

import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../../presentation/mixins/mixins.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'profile_presenter.dart';
import 'profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  final ProfilePresenter presenter;

  const ProfilePage({super.key, required this.presenter});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _cpfController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  late StreamSubscription<ProfileViewModel?> _viewModelSubscription;
  late StreamSubscription<String?> _successSubscription;
  late final String _originalEmail;

  final appStrings = AppI18n.current;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    _viewModelSubscription = widget.presenter.viewModel.listen((vm) {
      if (vm == null) return;
      if (_cpfController.text.isEmpty) {
        _cpfController.text = vm.maskedCpf;
        _nameController.text = vm.name;
        _emailController.text = vm.email;
        _phoneController.text = vm.formattedPhone;
        _originalEmail = vm.email;
      }
    });

    _successSubscription = widget.presenter.uiSuccessStream.listen((_) {
      final emailChanged = _emailController.text.trim().toLowerCase() !=
          _originalEmail.trim().toLowerCase();

      if (emailChanged) {
        _showEmailChangedDialog();
      } else {
        _showSuccessDialog();
      }
    });

    widget.presenter.loadData();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _viewModelSubscription.cancel();
    _successSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onSave() {
    FocusScope.of(context).unfocus();
    widget.presenter.validateAndSave(
      email: _emailController.text,
      phone: _phoneController.text,
    );
  }

  void _showSuccessDialog() {
    EbolsaDialog.show(
      context: context,
      title: appStrings.profileSaveSuccessTitle,
      description: appStrings.profileSaveSuccessDescription,
      actions: [
        EbolsaDialogAction(
          label: appStrings.profileSaveSuccessDoneButton,
          isPrimary: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _showEmailChangedDialog() {
    EbolsaDialog.show(
      context: context,
      title: appStrings.profileEmailChangedTitle,
      description: appStrings.profileEmailChangedDescription,
      actions: [
        EbolsaDialogAction(
          label: appStrings.profileEmailChangedDoneButton,
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context);
            await widget.presenter.logout();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ProfileViewModel?>(
          stream: widget.presenter.viewModel,
          initialData: const ProfileViewModel.empty(),
          builder: (context, snapshot) {
            final vm = snapshot.data ?? const ProfileViewModel.empty();
            return StreamBuilder<LoadingData?>(
                stream: widget.presenter.isLoadingStream,
                builder: (context, loadingSnapshot) {
                  final isLoading = loadingSnapshot.data?.isLoading ?? false;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
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
                          enabled: !isLoading,
                          borderWidth: 1,
                          borderColor: AppColors.secondary,
                          borderRadius: 16,
                          errorText: vm.emailError,
                        ),
                        const SizedBox(height: 16),
                        EbolsaPhoneField(
                          controller: _phoneController,
                          label: appStrings.profileMyDataPhone,
                          enabled: !isLoading,
                          errorText: vm.phoneError,
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder<String?>(
                            stream: widget.presenter.uiErrorStream,
                            builder: (context, errorSnapshot) {
                              if (errorSnapshot.data != null) {
                                return Column(
                                  children: [
                                    EbolsaErrorBanner(
                                        message: errorSnapshot.data!),
                                    const SizedBox(height: 12),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                        EbolsaLoadingButton(
                          onPressed: isLoading ? null : _onSave,
                          isLoading: isLoading,
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
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
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
                          label: appStrings
                              .profileChangePasswordConfirmNewPassword,
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
                  );
                });
          }),
    );
  }
}
