class ProfileViewModel {
  final String maskedCpf;
  final String name;
  final String email;
  final String formattedPhone;
  final String? emailError;
  final String? phoneError;
  final bool isSuccess;

  const ProfileViewModel({
    this.maskedCpf = '',
    this.name = '',
    this.email = '',
    this.formattedPhone = '',
    this.emailError,
    this.phoneError,
    this.isSuccess = false,
  });

  const ProfileViewModel.empty() : this();

  ProfileViewModel withErrors({String? emailError, String? phoneError}) =>
      ProfileViewModel(
        maskedCpf: maskedCpf,
        name: name,
        email: email,
        formattedPhone: formattedPhone,
        emailError: emailError,
        phoneError: phoneError,
      );

  ProfileViewModel withSuccess() => ProfileViewModel(
        maskedCpf: maskedCpf,
        name: name,
        email: email,
        formattedPhone: formattedPhone,
        isSuccess: true,
      );
}
