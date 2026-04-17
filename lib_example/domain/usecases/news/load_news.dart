import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadNews {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadNewsParams params,
  });
}

class LoadNewsParams {
  final String eventId;

  LoadNewsParams({
    required this.eventId,
  });
}
