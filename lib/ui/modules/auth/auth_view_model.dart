class AuthViewModel {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final bool isSuccess;

  const AuthViewModel({
    this.isLoading = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.isSuccess = false,
  });

  const AuthViewModel.initial() : this();

  const AuthViewModel.loading() : this(isLoading: true);

  const AuthViewModel.success() : this(isSuccess: true);

  AuthViewModel withError(String message) => AuthViewModel(
        errorMessage: message,
      );

  AuthViewModel withFieldError(String field, String message) => AuthViewModel(
        fieldErrors: {field: message},
      );

  bool hasFieldError(String field) => fieldErrors.containsKey(field);
  String? fieldError(String field) => fieldErrors[field];
}

class ForgotPasswordViewModel {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ForgotPasswordViewModel({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  const ForgotPasswordViewModel.initial() : this();
  const ForgotPasswordViewModel.loading() : this(isLoading: true);
  const ForgotPasswordViewModel.success() : this(isSuccess: true);

  ForgotPasswordViewModel withError(String message) =>
      ForgotPasswordViewModel(errorMessage: message);
}
