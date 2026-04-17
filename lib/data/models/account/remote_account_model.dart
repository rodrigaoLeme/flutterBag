import '../../../domain/entities/account/account_entity.dart';
import '../../http/http.dart';

class RemoteAccountModel {
  final String id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;

  RemoteAccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) throw HttpError.invalidData;
    return RemoteAccountModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  AccountEntity toEntity() => AccountEntity(
        id: id,
        name: name,
        email: email,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
