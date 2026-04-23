import '../../../domain/entities/user_entity.dart';

class RemoteAuthModel {
  final String id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;
  final int? expiresIn;

  const RemoteAuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  factory RemoteAuthModel.fromJson(Map<String, dynamic> json) {
    return RemoteAuthModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        if (expiresIn != null) 'expiresIn': expiresIn,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenExpiresAt: expiresIn != null
            ? DateTime.now().add(Duration(seconds: expiresIn!))
            : null,
      );

  factory RemoteAuthModel.fromEntity(UserEntity entity) => RemoteAuthModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
      );
}
