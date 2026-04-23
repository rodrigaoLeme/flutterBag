import 'dart:async';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../data/http/http_client.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';

class StreamCreateAccountPresenter implements CreateAccountPresenter {
  final CreateAccountUsecase createAccountUsecase;

  StreamCreateAccountPresenter({required this.createAccountUsecase});

  final _viewModelController = StreamController<AuthViewModel?>.broadcast();

  CreateAccountUsecaseParams? _params;

  @override
  Stream<AuthViewModel?> get viewModel => _viewModelController.stream;

  @override
  Future<void> createAccount(CreateAccountUsecaseParams params) async {
    final s = AppI18n.current;
    final errors = <String, String>{};

    final cleanCpf = params.cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (!CPFValidator.isValid(cleanCpf)) {
      errors['cpf'] = s.createAccountValidationInvalidCpf;
    }
    if (params.name.trim().length < 3) {
      errors['name'] = s.createAccountValidationFullNameRequired;
    }
    if (!RegExp(r'^[\w.]+@[\w]+\.\w{2,}$').hasMatch(params.email.trim())) {
      errors['email'] = s.createAccountValidationInvalidEmail;
    }
    final cleanPhone = params.phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 10) {
      errors['phone'] = s.createAccountValidationInvalidPhone;
    }
    if (params.password.length < 8) {
      errors['password'] = s.createAccountValidationPasswordMin;
    }
    if (params.password != params.passwordConfirmation) {
      errors['passwordConfirmation'] =
          s.createAccountValidationPasswordMismatch;
    }

    if (errors.isNotEmpty) {
      _params = null;
      _emit(AuthViewModel().withFieldErrors(errors));
      return;
    }

    _params = params;
    _emit(const AuthViewModel.valid());
  }

  @override
  Future<void> confirmAccount() async {
    if (_params == null) return;
    _emit(const AuthViewModel.loading());

    try {
      await createAccountUsecase.createAccount(_params!);
      _emit(const AuthViewModel.success());
    } on AccountAlreadyExistsException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } on HttpError catch (e) {
      final s = AppI18n.current;
      if (e == HttpError.noConnectivity) {
        _emit(AuthViewModel().withError(s.errorNoInternet));
        return;
      }
      if (e == HttpError.timeout) {
        _emit(AuthViewModel().withError(s.errorTimeout));
        return;
      }
      _emit(AuthViewModel().withError(s.errorUnexpected));
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
