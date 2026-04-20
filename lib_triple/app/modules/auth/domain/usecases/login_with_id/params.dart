class LoginWithIdParams {
  final String id;
  final String password;

  LoginWithIdParams(this.id, this.password);

  LoginWithIdParams copyWith({
    String? id,
    String? password,
  }) {
    return LoginWithIdParams(
      id ?? this.id,
      password ?? this.password,
    );
  }
}
