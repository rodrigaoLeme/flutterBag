class AddAccountViewModel {
  final String? nameError;
  final String? emailError;
  final String? cpfError;
  final String? phoneError;
  final String? passwordError;
  final String? passwordConfirmationError;
  final bool isFormValid;

  const AddAccountViewModel({
    this.nameError,
    this.emailError,
    this.cpfError,
    this.phoneError,
    this.passwordError,
    this.passwordConfirmationError,
    this.isFormValid = false,
  });

  const AddAccountViewModel.empty() : this();
}
