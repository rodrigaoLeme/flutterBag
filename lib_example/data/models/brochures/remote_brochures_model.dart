import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/brochures/brochures_entity.dart';
import '../../http/http.dart';

class RemoteBrochuresModel {
  final List<RemoteBrochuresResultModel> result;

  RemoteBrochuresModel({
    required this.result,
  });

  factory RemoteBrochuresModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final result = decodedResult
          .map((item) =>
              RemoteBrochuresResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteBrochuresModel(result: result);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  BrochuresEntity toEntity() => BrochuresEntity(
        result: result
            .map<BrochuresResultEntity>((event) => event.toEntity())
            .toList(),
      );
}

class RemoteBrochuresResultModel {
  final String externalId;
  final String eventExternalId;
  final String title;
  final String link;

  RemoteBrochuresResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.link,
  });

  factory RemoteBrochuresResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }

    return RemoteBrochuresResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      title: json['Title'],
      link: json['Link'],
    );
  }

  BrochuresResultEntity toEntity() => BrochuresResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        title: title,
        link: link,
      );
}
