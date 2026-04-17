import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadVoting {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadVotingParams params});
}

class LoadVotingParams {
  final String eventId;
  LoadVotingParams({
    required this.eventId,
  });
}
