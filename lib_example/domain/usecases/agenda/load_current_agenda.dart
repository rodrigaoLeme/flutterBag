import '../../entities/agenda/agenda_entity.dart';

abstract class LoadCurrentAgenda {
  Future<AgendaEntity?> load({
    required LoadCurrentAgendaParams params,
  });
}

class LoadCurrentAgendaParams {
  final String eventId;
  LoadCurrentAgendaParams({
    required this.eventId,
  });
}
