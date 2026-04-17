import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/translation/save_current_translation.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentTranslation implements SaveCurrentTranslation {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentTranslation({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String lenguage) async {
    try {
      await sharedPreferencesStorage.save(
          key: SecureStorageKey.lenguage, value: lenguage);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
