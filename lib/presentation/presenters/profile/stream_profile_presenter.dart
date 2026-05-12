import 'dart:async';

import '../../../data/http/http_client.dart';
import '../../../domain/usecases/account/update_contact_info.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../infra/repositories/account/remote_update_contact_info.dart';
import '../../../main/di/injection_container.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../share/current_account.dart';
import '../../../ui/modules/profile/profile_presenter.dart';
import '../../../ui/modules/profile/profile_view_model.dart';
import '../../mixins/mixins.dart';

class StreamProfilePresenter
    with SessionManager, LoadingManager, UIErrorManager, UISuccessManager
    implements ProfilePresenter {
  final UpdateContactInfoUsecase updateContactInfoUsecase;
  final LogoutUsecase logoutUsecase;

  StreamProfilePresenter({
    required this.updateContactInfoUsecase,
    required this.logoutUsecase,
  });

  final _viewModelController = StreamController<ProfileViewModel?>.broadcast();

  @override
  Stream<ProfileViewModel?> get viewModel => _viewModelController.stream;

  @override
  void loadData() {
    final account = sl<CurrentAccount>();
    _viewModelController.add(ProfileViewModel(
      maskedCpf: _maskCpf(account.userCpf),
      name: account.name,
      email: account.email,
      formattedPhone: _formatPhone(account.mobileNumber),
    ));
  }

  @override
  void validateAndSave({
    required String email,
    required String phone,
  }) {
    final emailError =
        !RegExp(r'^[\w.+]+@[\w]+\.\w{2,}$').hasMatch(email.trim())
            ? AppI18n.current.createAccountValidationInvalidEmail
            : null;

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final phoneError = cleanPhone.length < 10
        ? AppI18n.current.createAccountValidationInvalidPhone
        : null;

    if (emailError != null || phoneError != null) {
      final current = _currentViewModel();
      _viewModelController.add(current.withErrors(
        emailError: emailError,
        phoneError: phoneError,
      ));
      return;
    }

    _save(email: email.trim(), phone: cleanPhone);
  }

  Future<void> _save({
    required String email,
    required String phone,
  }) async {
    isLoading = LoadingData(isLoading: true);

    try {
      await updateContactInfoUsecase.update(
        UpdateContactInfoParams(email: email, mobileNumber: phone),
      );

      final account = sl<CurrentAccount>().account!;
      sl<CurrentAccount>().set(account.copyWith(
        email: email,
        mobileNumber: phone,
      ));

      uiSuccess = AppI18n.current.profileSaveSuccess;
    } on UpdateContactInfoException catch (e) {
      uiError = e.message;
    } on HttpError catch (e) {
      if (handleHttpError(e)) return;
      uiError = AppI18n.current.errorUnexpected;
    } catch (e) {
      uiError = AppI18n.current.errorUnexpected;
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  ProfileViewModel _currentViewModel() {
    final account = sl<CurrentAccount>();
    return ProfileViewModel(
      maskedCpf: _maskCpf(account.userCpf),
      name: account.name,
      email: account.email,
      formattedPhone: _formatPhone(account.mobileNumber),
    );
  }

  String _maskCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return cpf;
    final g2 = digits.substring(3, 6);
    final g3 = digits.substring(6, 9);
    return '***.$g2.$g3-**';
  }

  String _formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    }
    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    }
    return phone;
  }

  @override
  void dispose() {
    _viewModelController.close();
    disposeSession();
  }

  @override
  Future<void> logout() async {
    await logoutUsecase.logout();
    sl<CurrentAccount>().clear();
  }
}
