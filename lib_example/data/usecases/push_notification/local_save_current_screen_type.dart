import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/push_notification/save_current_screen_type.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentScreenType implements SaveCurrentScreenType {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentScreenType({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String? message) async {
    try {
      await sharedPreferencesStorage.save(
        key: SecureStorageKey.notificationType,
        value: message ?? '',
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
