import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadExternalFood {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadExternalFoodParams params});
}

class LoadExternalFoodParams {
  final String eventId;
  LoadExternalFoodParams({
    required this.eventId,
  });
}
