class AuthViewModel {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final bool isSuccess;
  final String? loginRoute;
  final bool isValid;

  const AuthViewModel({
    this.isLoading = false,
    this.isValid = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.isSuccess = false,
    this.loginRoute,
  });

  const AuthViewModel.initial() : this();

  const AuthViewModel.loading() : this(isLoading: true);

  AuthViewModel withSuccess(String route) =>
      AuthViewModel(isSuccess: true, loginRoute: route);
  const AuthViewModel.valid() : this(isValid: true);

  const AuthViewModel.success() : this(isSuccess: true);

  AuthViewModel withError(String message) => AuthViewModel(
        errorMessage: message,
      );

  AuthViewModel withFieldError(String field, String message) => AuthViewModel(
        fieldErrors: {field: message},
      );

  AuthViewModel withFieldErrors(Map<String, String> errors) => AuthViewModel(
        fieldErrors: errors,
      );

  bool hasFieldError(String field) => fieldErrors.containsKey(field);
  String? fieldError(String field) => fieldErrors[field];
}

class ForgotPasswordViewModel {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? emailMasked;

  const ForgotPasswordViewModel({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.emailMasked,
  });

  const ForgotPasswordViewModel.initial() : this();
  const ForgotPasswordViewModel.loading() : this(isLoading: true);
  const ForgotPasswordViewModel.success() : this(isSuccess: true);

  ForgotPasswordViewModel withSuccess(String emailMasked) =>
      ForgotPasswordViewModel(
        isSuccess: true,
        emailMasked: emailMasked,
      );

  ForgotPasswordViewModel withError(String message) =>
      ForgotPasswordViewModel(errorMessage: message);
}
