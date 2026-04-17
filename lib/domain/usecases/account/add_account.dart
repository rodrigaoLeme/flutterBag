import '../../entities/account/account_entity.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams {
  final String name;
  final String email;
  final String cpf;
  final String phone;
  final String password;
  final String passwordConfirmation;

  AddAccountParams({
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });
}
