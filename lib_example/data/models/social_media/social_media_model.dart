import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/social_media.dart/social_media_entity.dart';
import '../../http/http_error.dart';

class RemoteSocialMediaModel {
  final SocialMediaResultModel? socialMediaModel;

  RemoteSocialMediaModel({
    required this.socialMediaModel,
  });

  factory RemoteSocialMediaModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as Map;

      return RemoteSocialMediaModel(
        socialMediaModel: SocialMediaResultModel.fromJson(decodedResult),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
  SocialMediaEntity toEntity() => SocialMediaEntity(
        socialMedia: socialMediaModel?.toEntity(),
      );
}

class SocialMediaResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  SocialMediaResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });

  factory SocialMediaResultModel.fromJson(Map json) {
    return SocialMediaResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      text: json['Text'],
      link: json['Link'],
    );
  }

  SocialMediaResultEntity toEntity() => SocialMediaResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        text: text,
        link: link,
      );
}
