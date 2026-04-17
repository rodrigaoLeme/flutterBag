import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadAgenda {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadScheduleParams params});
}

class LoadScheduleParams {
  final String eventSchedule;
  LoadScheduleParams({
    required this.eventSchedule,
  });
}
