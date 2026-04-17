class AccountEntity {
  final String id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });
}
