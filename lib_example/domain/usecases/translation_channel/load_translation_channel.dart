import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadTranslationChannel {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadTranslationChannelParams params});
}

class LoadTranslationChannelParams {
  final String eventId;
  LoadTranslationChannelParams({
    required this.eventId,
  });
}
