import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/support/support.dart';
import '../../http/http.dart';

class RemoteSupportModel {
  final List<RemoteSupportResultModel>? support;

  RemoteSupportModel({
    required this.support,
  });

  factory RemoteSupportModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final support = decodedResult
          .map((item) =>
              RemoteSupportResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteSupportModel(support: support);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
}

class RemoteSupportResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? description;

  RemoteSupportResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.description,
  });

  factory RemoteSupportResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteSupportResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      title: json['Title'],
      description: json['Description'],
    );
  }

  SupportResultEntity toEntity() => SupportResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        title: title,
        description: description,
      );
}
