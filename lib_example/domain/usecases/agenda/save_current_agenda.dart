abstract class SaveCurrentAgenda {
  Future<void> save({required SaveCurrentAgendaParams params});
}

class SaveCurrentAgendaParams {
  final String eventId;
  final String data;
  SaveCurrentAgendaParams({
    required this.eventId,
    required this.data,
  });
}
