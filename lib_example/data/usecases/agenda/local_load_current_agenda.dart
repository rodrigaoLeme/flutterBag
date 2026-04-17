import 'dart:convert';

import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/agenda/load_current_agenda.dart';
import '../../cache/cache.dart';
import '../../models/agenda/remote_agenda_model.dart';

class LocalLoadCurrentAgenda implements LoadCurrentAgenda {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentAgenda({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<AgendaEntity?> load({required LoadCurrentAgendaParams params}) async {
    try {
      final key = '${SecureStorageKey.currentAgenda}_${params.eventId}';
      final data = await sharedPreferencesStorage.fetch(key);
      if (data == null) throw DomainError.expiredSession;
      final model = RemoteAgendaModel.fromJson(jsonDecode(data)).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
