import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/event/delete_current_event.dart';
import '../../cache/cache.dart';

class LocalDeleteCurrentEvent implements DeleteCurrentEvent {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalDeleteCurrentEvent({required this.sharedPreferencesStorage});

  @override
  Future<void> delete() async {
    try {
      await sharedPreferencesStorage.clean();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
