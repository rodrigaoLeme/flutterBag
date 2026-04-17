import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentAccount({required this.sharedPreferencesStorage});

  @override
  Future<AccountEntity?> load() async {
    try {
      final token =
          await sharedPreferencesStorage.fetch(SecureStorageKey.accessToken);
      if (token == null) throw DomainError.expiredSession;
      // Retorna entity mínima — o token é o que importa para autenticação
      return AccountEntity(
        id: '',
        name: '',
        email: token,
        accessToken: token,
        refreshToken: '',
      );
    } catch (_) {
      throw DomainError.expiredSession;
    }
  }
}
