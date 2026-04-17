import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadTransport {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadTransportParams params});
}

class LoadTransportParams {
  final String eventId;
  LoadTransportParams({
    required this.eventId,
  });
}
