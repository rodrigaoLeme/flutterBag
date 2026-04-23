import 'dart:async';

import '../../../data/http/http_client.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';

class StreamCreateAccountPresenter implements CreateAccountPresenter {
  final CreateAccountUsecase createAccountUsecase;

  StreamCreateAccountPresenter({required this.createAccountUsecase});

  final _viewModelController = StreamController<AuthViewModel?>.broadcast();

  @override
  Stream<AuthViewModel?> get viewModel => _viewModelController.stream;

  @override
  Future<void> createAccount(CreateAccountUsecaseParams params) async {
    _emit(const AuthViewModel.loading());

    try {
      await createAccountUsecase.createAccount(params);
      _emit(const AuthViewModel.success());
    } on CreateAccountValidationException catch (e) {
      _emit(AuthViewModel().withFieldError(e.field, e.message));
    } on AccountAlreadyExistsException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } on HttpError catch (e) {
      final appStrings = AppI18n.current;

      if (e == HttpError.noConnectivity) {
        _emit(AuthViewModel().withError(appStrings.errorNoInternet));
        return;
      }
      if (e == HttpError.timeout) {
        _emit(AuthViewModel().withError(appStrings.errorTimeout));
        return;
      }
      _emit(AuthViewModel().withError(appStrings.errorUnexpected));
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
