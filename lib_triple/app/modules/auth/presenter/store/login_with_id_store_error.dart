class LoginWithIdStoreError {
  final String? idFieldError;
  final String? passwordFieldError;
  final String? authError;

  const LoginWithIdStoreError({this.idFieldError, this.passwordFieldError, this.authError});
}
