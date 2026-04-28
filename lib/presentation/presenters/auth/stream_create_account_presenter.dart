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
    //TODO: descomentar a linha abaixo após os testes para impedir o uso do "+"
    //if (!RegExp(r'^[\w.]+@[\w]+\.\w{2,}$').hasMatch(params.email.trim())) {
    if (!RegExp(r'^[\w.+]+@[\w]+\.\w{2,}$').hasMatch(params.email.trim())) {
      errors['email'] = s.createAccountValidationInvalidEmail;
    }
    final cleanPhone = params.phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 10) {
      errors['phone'] = s.createAccountValidationInvalidPhone;
    }
    if (params.password.length < 12) {
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
      await createAccountUsecase.createAccount(
        CreateAccountUsecaseParams(
          name: _params!.name,
          email: _params!.email,
          cpf: _params!.cpf,
          phone: _params!.phone,
          password: _params!.password,
          passwordConfirmation: _params!.passwordConfirmation,
          termsOfUseAccepted: true,
        ),
      );
      _emit(const AuthViewModel.success());
    } on EmailVerificationRequiredException {
      /// Aqui existe uma regra que o usuário deve terminar o processo clicando
      /// em um link que ele recebeu no e-mail.
      _emit(const AuthViewModel.success());
    } on AccountAlreadyExistsException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } on CreateAccountValidationException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } on RateLimitException {
      _emit(AuthViewModel().withError(AppI18n.current.errorRateLimit));
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
