import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadSponsor {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSponsorParams params});
}

class LoadSponsorParams {
  final String eventId;
  LoadSponsorParams({
    required this.eventId,
  });
}
