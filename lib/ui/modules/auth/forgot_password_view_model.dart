class ForgotPasswordViewModel {
  final String? identifierError;
  final bool isFormValid;

  const ForgotPasswordViewModel({
    this.identifierError,
    this.isFormValid = false,
  });

  const ForgotPasswordViewModel.empty() : this();
}
