import 'dart:async';

import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';

class StreamAccountNotConfirmedPresenter
    implements AccountNotConfirmedPresenter {
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;

  StreamAccountNotConfirmedPresenter({
    required this.sendEmailVerificationUseCase,
  });

  final _viewModelController = StreamController<AuthViewModel?>.broadcast();

  @override
  Stream<AuthViewModel?> get viewModel => _viewModelController.stream;

  @override
  Future<void> sendEmailVerification(SendEmailVerificationParams params) async {
    _emit(const AuthViewModel.loading());

    try {
      await sendEmailVerificationUseCase.send(params);
      _emit(const AuthViewModel.success());
    } on SendEmailVerificationException catch (e) {
      _emit(const AuthViewModel().withError(e.message));
    } catch (_) {
      _emit(const AuthViewModel().withError(AppI18n.current.errorUnexpected));
    }
  }

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

  void _emit(AuthViewModel vm) {
    if (!_viewModelController.isClosed) _viewModelController.add(vm);
  }

  @override
  void dispose() => _viewModelController.close();
}
