import '../domain/entities/account_entity.dart';

class CurrentAccount {
  AccountEntity? _account;

  AccountEntity? get account => _account;
  String get name => _account?.name ?? '';
  String get email => _account?.email ?? '';
  String get mobileNumber => _account?.mobileNumber ?? '';
  bool get emailConfirmed => _account?.emailConfirmed ?? false;
  bool get isLoaded => _account != null;
  String get userCpf => _account?.cpf ?? '';

  void set(AccountEntity account) => _account = account;
  void clear() => _account = null;
}
