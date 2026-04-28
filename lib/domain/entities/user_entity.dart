class UserEntity {
  final String id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;
  final DateTime? tokenExpiresAt;
  final DateTime? refreshTokenExpiryTime;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.tokenExpiresAt,
    this.refreshTokenExpiryTime,
  });

  bool get isTokenExpired {
    if (tokenExpiresAt == null) return false;
    return DateTime.now().isAfter(tokenExpiresAt!);
  }

  bool get needsRefresh {
    if (tokenExpiresAt == null) return false;
    return DateTime.now().isAfter(
      tokenExpiresAt!.subtract(const Duration(minutes: 5)),
    );
  }
}
