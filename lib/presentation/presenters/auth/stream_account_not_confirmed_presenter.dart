import 'dart:async';

import '../../../domain/usecases/account/update_contact_info.dart';
import '../../../infra/repositories/account/remote_update_contact_info.dart';
import '../../../main/di/injection_container.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../share/current_account.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';

class StreamAccountNotConfirmedPresenter
    implements AccountNotConfirmedPresenter {
  final UpdateContactInfoUsecase updateContactInfoUsecase;

  StreamAccountNotConfirmedPresenter({
    required this.updateContactInfoUsecase,
  });

  final _viewModelController = StreamController<AuthViewModel?>.broadcast();

  @override
  Stream<AuthViewModel?> get viewModel => _viewModelController.stream;

  @override
  void validateEmail(String email) {
    if (!RegExp(r'^[\w.+]+@[\w]+\.\w{2,}$').hasMatch(email.trim())) {
      _emit(AuthViewModel().withFieldError(
        'email',
        AppI18n.current.createAccountValidationInvalidEmail,
      ));
      return;
    }
    _emit(const AuthViewModel.valid()); // ← isValid: true
  }

  @override
  Future<void> updateContactInfo(String email) async {
    _emit(const AuthViewModel.loading());

    try {
      await updateContactInfoUsecase.update(
        UpdateContactInfoParams(
          email: email.trim().toLowerCase(),
          mobileNumber: sl<CurrentAccount>().mobileNumber,
        ),
      );
      _emit(const AuthViewModel.success());
    } on UpdateContactInfoException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } catch (_) {
      _emit(AuthViewModel().withError(AppI18n.current.errorUnexpected));
    }
  }

  void _emit(AuthViewModel vm) {
    if (!_viewModelController.isClosed) _viewModelController.add(vm);
  }

  @override
  void dispose() => _viewModelController.close();
}
