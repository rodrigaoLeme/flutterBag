import 'dart:async';

import '../../../data/http/http_client.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/auth/auth_presenter.dart';
import '../../../ui/modules/auth/auth_view_model.dart';

class StreamForgotPasswordPresenter implements ForgotPasswordPresenter {
  final ForgotPasswordUsecase forgotPasswordUsecase;

  StreamForgotPasswordPresenter({required this.forgotPasswordUsecase});

  final _viewModelController =
      StreamController<ForgotPasswordViewModel?>.broadcast();

  @override
  Stream<ForgotPasswordViewModel?> get viewModel => _viewModelController.stream;

  @override
  Future<void> forgotPassword(ForgotPasswordUsecaseParams params) async {
    _emit(const ForgotPasswordViewModel.loading());

    try {
      final result = await forgotPasswordUsecase.forgotPassword(params);
      _emit(ForgotPasswordViewModel().withSuccess(result.emailMasked));
    } on ForgotPasswordValidationException catch (e) {
      _emit(ForgotPasswordViewModel().withError(e.message));
    } on HttpError catch (e) {
      final appStrings = AppI18n.current;

      if (e == HttpError.noConnectivity) {
        _emit(ForgotPasswordViewModel().withError(appStrings.errorNoInternet));
        return;
      }
      _emit(ForgotPasswordViewModel().withError(appStrings.errorUnexpected));
    } catch (_) {
      _emit(
          ForgotPasswordViewModel().withError(AppI18n.current.errorUnexpected));
    }
  }

  void _emit(ForgotPasswordViewModel vm) {
    if (!_viewModelController.isClosed) _viewModelController.add(vm);
  }

  @override
  void dispose() => _viewModelController.close();
}
