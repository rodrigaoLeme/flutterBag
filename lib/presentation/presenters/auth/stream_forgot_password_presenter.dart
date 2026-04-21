import 'dart:async';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/forgot_password.dart';
import '../../../ui/modules/auth/forgot_password_presenter.dart';
import '../../mixins/mixins.dart';

class StreamForgotPasswordPresenter
    with LoadingManager, NavigationManager, UIErrorManager
    implements ForgotPasswordPresenter {
  final ForgotPassword _forgotPasswordUsecase;

  StreamForgotPasswordPresenter({required ForgotPassword forgotPassword})
      : _forgotPasswordUsecase = forgotPassword;

  final _isSuccessController = StreamController<bool?>.broadcast();

  @override
  Stream<bool?> get isSuccessStream => _isSuccessController.stream;

  @override
  Future<void> forgotPassword({required String identifier}) async {
    try {
      isLoading = LoadingData(isLoading: true);
      uiError = null;
      await _forgotPasswordUsecase.send(identifier: identifier);
      _isSuccessController.add(true);
    } on DomainError {
      uiError = 'Não foi possível enviar o link. Tente novamente.';
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  void dispose() {
    _isSuccessController.close();
  }
}
