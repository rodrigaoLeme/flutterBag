import 'auth_view_model.dart';

abstract class LoginPresenter {
  Stream<AuthViewModel?> get viewModel;
  Stream<bool> get isSessionExpiredStream;
  Future<void> login({required String identifier, required String password});
  void dispose();
}

abstract class CreateAccountPresenter {
  Stream<AuthViewModel?> get viewModel;
  Future<void> createAccount({
    required String name,
    required String email,
    required String cpf,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });
  void dispose();
}

abstract class ForgotPasswordPresenter {
  Stream<ForgotPasswordViewModel?> get viewModel;
  Future<void> forgotPassword({required String identifier});
  void dispose();
}
