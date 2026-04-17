import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadSpiritual {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSpiritualParams params});
}

class LoadSpiritualParams {
  final String eventId;
  LoadSpiritualParams({
    required this.eventId,
  });
}
