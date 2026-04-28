import '../../../domain/entities/user_entity.dart';

class RemoteAuthModel {
  final String token;
  final String refreshToken;
  final DateTime? refreshTokenExpiryTime;

  const RemoteAuthModel({
    required this.token,
    required this.refreshToken,
    this.refreshTokenExpiryTime,
  });

  /// Mapeia a resposta real da API:
  /// { "token": "...", "refreshToken": "...", "refreshTokenExpiryTime": "..." }
  /// Os campos id/name/email são extraídos dos claims do JWT.
  factory RemoteAuthModel.fromJson(Map<String, dynamic> json) {
    final refreshExpiryRaw = json['refreshTokenExpiryTime'] as String?;
    final refreshTokenExpiryTime = refreshExpiryRaw != null
        ? DateTime.tryParse(refreshExpiryRaw)?.toLocal()
        : null;

    return RemoteAuthModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiryTime: refreshTokenExpiryTime,
    );
  }

  UserEntity toEntity() => UserEntity(
        id: '',
        name: '',
        email: '',
        accessToken: token,
        refreshToken: refreshToken,
      );
}
