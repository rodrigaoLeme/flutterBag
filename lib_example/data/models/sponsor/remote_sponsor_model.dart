import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sponsor/sponsor_entity.dart';
import '../../http/http.dart';

class RemoteSponsorModel {
  final List<SponsorResultModel>? sponsor;

  RemoteSponsorModel({
    required this.sponsor,
  });

  factory RemoteSponsorModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final sponsor = decodedResult
          .map((item) =>
              SponsorResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteSponsorModel(sponsor: sponsor);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
}

class SponsorResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? link;
  final String? photoUrl;

  SponsorResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.link,
    required this.photoUrl,
  });

  factory SponsorResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }
    return SponsorResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      name: json['Name'],
      link: json['Link'],
      photoUrl: json['PhotoUrl'],
    );
  }

  SponsorResultEntity toEntity() => SponsorResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        name: name,
        link: link,
        photoUrl: photoUrl,
      );
}
