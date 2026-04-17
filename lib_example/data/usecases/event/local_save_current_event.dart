import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/event/save_current_event.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentEvent implements SaveCurrentEvent {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentEvent({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String event) async {
    try {
      await sharedPreferencesStorage.save(
          key: SecureStorageKey.currentEvent, value: event);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
