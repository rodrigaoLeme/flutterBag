import '../../../domain/entities/user_entity.dart';

class RemoteAuthModel {
  final String token;
  final String refreshToken;

  const RemoteAuthModel({
    required this.token,
    required this.refreshToken,
  });

  factory RemoteAuthModel.fromJson(Map<String, dynamic> json) {
    return RemoteAuthModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
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
