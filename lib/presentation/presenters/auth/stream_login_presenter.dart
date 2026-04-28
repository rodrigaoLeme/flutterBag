import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../data/http/http_client.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';
import '../../mixins/mixins.dart';

class StreamLoginPresenter with SessionManager implements LoginPresenter {
  final LoginUsecase loginUsecase;
  final SecureStorage secureStorage;

  StreamLoginPresenter({
    required this.loginUsecase,
    required this.secureStorage,
  });

  final _viewModelController = StreamController<AuthViewModel?>.broadcast();

  @override
  Stream<AuthViewModel?> get viewModel => _viewModelController.stream;

  @override
  Future<void> login(LoginUsecaseParams params) async {
    _emit(const AuthViewModel.loading());

    try {
      await loginUsecase.login(params);
      _emit(AuthViewModel().withSuccess(Routes.home));
    } on LoginValidationException catch (e) {
      if (e.field.isNotEmpty) {
        _emit(AuthViewModel().withFieldError(e.field, e.message));
      } else {
        _emit(AuthViewModel().withError(e.message));
      }
    } on InvalidCredentialsException catch (e) {
      _emit(AuthViewModel().withError(e.message));
    } on HttpError catch (e) {
      final appStrings = AppI18n.current;

      if (e == HttpError.forbidden) {
        _emit(AuthViewModel().withError(appStrings.loginAccessDenied));
        return;
      }
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
    if (!_viewModelController.isClosed) {
      _viewModelController.add(vm);
    }
  }

  @override
  void dispose() {
    _viewModelController.close();
    disposeSession();
  }
}
