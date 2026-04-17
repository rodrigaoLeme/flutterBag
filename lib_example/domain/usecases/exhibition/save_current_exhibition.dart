abstract class SaveCurrentExhibition {
  Future<void> save({required SaveCurrentExhibitionParams params});
}

class SaveCurrentExhibitionParams {
  final String eventId;
  final String data;
  SaveCurrentExhibitionParams({
    required this.eventId,
    required this.data,
  });
}
