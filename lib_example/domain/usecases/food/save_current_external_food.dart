abstract class SaveCurrentExternalFood {
  Future<void> save({required SaveCurrentExternalFoodParams params});
}

class SaveCurrentExternalFoodParams {
  final String eventId;
  final String data;
  SaveCurrentExternalFoodParams({
    required this.eventId,
    required this.data,
  });
}
