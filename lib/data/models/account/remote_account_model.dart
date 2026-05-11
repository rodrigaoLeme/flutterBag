import '../../../domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String name;
  final String email;
  final String mobileNumber;
  final bool emailConfirmed;

  const RemoteAccountModel({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.emailConfirmed,
  });

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) =>
      RemoteAccountModel(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        mobileNumber: json['mobileNumber'] as String? ?? '',
        emailConfirmed: json['emailConfirmed'] as bool? ?? false,
      );

  AccountEntity toEntity() => AccountEntity(
      name: name,
      email: email,
      mobileNumber: mobileNumber,
      emailConfirmed: emailConfirmed);
}
