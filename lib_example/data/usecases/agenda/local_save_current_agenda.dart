import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/agenda/save_current_agenda.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAgenda implements SaveCurrentAgenda {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentAgenda({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save({required SaveCurrentAgendaParams params}) async {
    try {
      final key = '${SecureStorageKey.currentAgenda}_${params.eventId}';

      await sharedPreferencesStorage.save(key: key, value: params.data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
