import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentTranslation implements LoadCurrentTranslation {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentTranslation({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<String?> load() async {
    try {
      final data =
          await sharedPreferencesStorage.fetch(SecureStorageKey.lenguage);
      if (data == null) throw DomainError.expiredSession;
      return data;
    } catch (error) {
      return null;
    }
  }
}
