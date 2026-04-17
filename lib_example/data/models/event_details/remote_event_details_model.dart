import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/event_details/event_details_entity.dart';
import '../../http/http_error.dart';
import '../event/remote_event_model.dart';

class EventDetailsResultModel {
  final EventResultModel? event;

  EventDetailsResultModel({
    required this.event,
  });

  factory EventDetailsResultModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as Map;

      return EventDetailsResultModel(
        event: EventResultModel.fromJson(decodedResult),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  EventDetailsEntity toEntity() => EventDetailsEntity(
        event: event?.toEntity(),
      );
}
