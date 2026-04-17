import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/accessibility/accessibility_entity.dart';
import '../../http/http_error.dart';

class RemoteAccessibilityModel {
  final AccessibilityResultModel? accessibility;

  RemoteAccessibilityModel({
    required this.accessibility,
  });

  factory RemoteAccessibilityModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as Map;

      return RemoteAccessibilityModel(
        accessibility: AccessibilityResultModel.fromJson(decodedResult),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
  AccessibilityEntity toEntity() => AccessibilityEntity(
        accessibility: accessibility?.toEntity(),
      );
}

class AccessibilityResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  AccessibilityResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });

  factory AccessibilityResultModel.fromJson(Map json) {
    return AccessibilityResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      text: json['Text'],
      link: json['Link'],
    );
  }

  AccessibilityResultEntity toEntity() => AccessibilityResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        text: text,
        link: link,
      );
}
