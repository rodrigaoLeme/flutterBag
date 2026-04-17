import 'dart:convert';

import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../cache/cache.dart';
import '../../models/event/remote_event_model.dart';

class LocalLoadCurrentEvent implements LoadCurrentEvent {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentEvent({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<EventResultEntity?> load() async {
    try {
      final data =
          await sharedPreferencesStorage.fetch(SecureStorageKey.currentEvent);
      if (data == null) throw DomainError.expiredSession;
      final model = EventResultModel.fromJson(jsonDecode(data)).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
