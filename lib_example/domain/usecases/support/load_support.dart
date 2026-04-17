import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadSupport {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSupportParams params});
}

class LoadSupportParams {
  final String eventId;
  LoadSupportParams({
    required this.eventId,
  });
}
