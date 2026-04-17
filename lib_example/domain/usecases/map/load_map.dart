import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadMap {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadMapParams params,
  });
}

class LoadMapParams {
  final String eventId;

  LoadMapParams({
    required this.eventId,
  });
}
