import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/translation_channel/translation_channel_entity.dart';
import '../../http/http_error.dart';

class RemoteTranslationChannelModel {
  final TranslationChannelResultModel? translationChannel;

  RemoteTranslationChannelModel({
    required this.translationChannel,
  });

  factory RemoteTranslationChannelModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as Map;

      return RemoteTranslationChannelModel(
        translationChannel:
            TranslationChannelResultModel.fromJson(decodedResult),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
  TranslationChannelEntity toEntity() => TranslationChannelEntity(
        translationChannel: translationChannel?.toEntity(),
      );
}

class TranslationChannelResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  TranslationChannelResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });

  factory TranslationChannelResultModel.fromJson(Map json) {
    return TranslationChannelResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      text: json['Text'],
      link: json['Link'],
    );
  }

  TranslationChannelResultEntity toEntity() => TranslationChannelResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        text: text,
        link: link,
      );
}
