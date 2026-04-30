class AuthViewModel {
  final bool isLoading;
  final bool isSuccess;
  final bool isValid;
  final bool isEmailNotConfirmed;
  final String? errorMessage;
  final String? loginRoute;
  final Map<String, String> fieldErrors;

  const AuthViewModel({
    this.isLoading = false,
    this.isSuccess = false,
    this.isValid = false,
    this.isEmailNotConfirmed = false,
    this.errorMessage,
    this.loginRoute,
    this.fieldErrors = const {},
  });

  const AuthViewModel.initial() : this();

  const AuthViewModel.loading() : this(isLoading: true);

  const AuthViewModel.valid() : this(isValid: true);

  const AuthViewModel.success() : this(isSuccess: true);

  AuthViewModel withSuccess(String route) =>
      AuthViewModel(isSuccess: true, loginRoute: route);

  AuthViewModel withError(String message) => AuthViewModel(
        errorMessage: message,
      );

  AuthViewModel withFieldError(String field, String message) => AuthViewModel(
        fieldErrors: {field: message},
      );

  AuthViewModel withFieldErrors(Map<String, String> errors) => AuthViewModel(
        fieldErrors: errors,
      );

  AuthViewModel withEmailNotConfirmed() => AuthViewModel(
        isEmailNotConfirmed: true,
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
