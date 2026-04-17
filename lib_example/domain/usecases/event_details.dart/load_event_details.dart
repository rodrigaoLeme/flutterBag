import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadEventDetails {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadEventDetailsParams params});
}

class LoadEventDetailsParams {
  final String eventId;
  LoadEventDetailsParams({
    required this.eventId,
  });
}
