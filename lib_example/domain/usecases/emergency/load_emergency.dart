import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadEmergency {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadEmergencyParams params});
}

class LoadEmergencyParams {
  final String eventId;
  LoadEmergencyParams({
    required this.eventId,
  });
}
