import '../../../domain/entities/account/account_entity.dart';
import '../../http/http.dart';

class RemoteAccountModel {
  final int id;
  final String name;
  final String email;

  RemoteAccountModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory RemoteAccountModel.fromEntity(AccountEntity entity) =>
      RemoteAccountModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
      );

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('id')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  AccountEntity toEntity() => AccountEntity(
        id: id,
        email: email,
        name: name,
      );
}
