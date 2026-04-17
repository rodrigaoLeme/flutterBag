import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadInternalFood {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadInternalFoodParams params});
}

class LoadInternalFoodParams {
  final String eventId;
  LoadInternalFoodParams({
    required this.eventId,
  });
}
