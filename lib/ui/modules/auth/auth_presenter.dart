import '../../../domain/usecases/auth/auth_usecases.dart';
import 'auth_view_model.dart';

abstract class LoginPresenter {
  Stream<AuthViewModel?> get viewModel;
  Stream<bool> get isSessionExpiredStream;
  Future<void> login(LoginUsecaseParams params);
  void dispose();
}

abstract class CreateAccountPresenter {
  Stream<AuthViewModel?> get viewModel;
  Future<void> createAccount(CreateAccountUsecaseParams params);
  void dispose();
}

abstract class ForgotPasswordPresenter {
  Stream<ForgotPasswordViewModel?> get viewModel;
  Future<void> forgotPassword(ForgotPasswordUsecaseParams params);
  void dispose();
}
