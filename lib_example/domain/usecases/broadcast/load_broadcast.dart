import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadBroadcast {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadBroadcastParams params});
}

class LoadBroadcastParams {
  final String eventId;
  LoadBroadcastParams({
    required this.eventId,
  });
}
