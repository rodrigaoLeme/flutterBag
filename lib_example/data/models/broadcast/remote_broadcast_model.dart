import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/broadcast/broadcast_entity.dart';
import '../../http/http.dart';

class RemoteBroadcastModel {
  final List<RemoteBroadcastResultModel> result;

  RemoteBroadcastModel({
    required this.result,
  });

  factory RemoteBroadcastModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final result = decodedResult
          .map((item) =>
              RemoteBroadcastResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteBroadcastModel(result: result);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  BroadcastEntity toEntity() => BroadcastEntity(
        result: result
            .map<BroadcastResultEntity>((event) => event.toEntity())
            .toList(),
      );
}

class RemoteBroadcastResultModel {
  final String externalId;
  final String title;
  final String link;
  final String language;
  final String dayPeriod;
  final String selectedDay;
  final int order;

  RemoteBroadcastResultModel({
    required this.externalId,
    required this.title,
    required this.link,
    required this.language,
    required this.dayPeriod,
    required this.selectedDay,
    required this.order,
  });

  factory RemoteBroadcastResultModel.fromJson(Map json) {
    if (!json.containsKey('EventExternalId')) {
      throw HttpError.invalidData;
    }

    return RemoteBroadcastResultModel(
      externalId: json['EventExternalId'],
      title: json['Title'],
      link: json['Link'],
      language: json['Language'],
      dayPeriod: json['DayPeriod'],
      selectedDay: json['SelectedDay'],
      order: json['Order'],
    );
  }

  BroadcastResultEntity toEntity() => BroadcastResultEntity(
        externalId: externalId,
        title: title,
        link: link,
        language: language,
        dayPeriod: dayPeriod,
        selectedDay: selectedDay,
        order: order,
      );
}
