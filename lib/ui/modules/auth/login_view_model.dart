class LoginViewModel {
  final String? identifierError;
  final String? passwordError;

  const LoginViewModel({
    this.identifierError,
    this.passwordError,
  });

  const LoginViewModel.empty() : this();
}
