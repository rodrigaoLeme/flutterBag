import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/transport/transport_entity.dart';
import '../../http/http_error.dart';

class RemoteTransportModel {
  final RemoteTransportResultModel? transportation;

  RemoteTransportModel({
    required this.transportation,
  });

  factory RemoteTransportModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as Map;

      return RemoteTransportModel(
        transportation: RemoteTransportResultModel.fromJson(decodedResult),
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
  TransportEntity toEntity() => TransportEntity(
        transport: transportation?.toEntity(),
      );
}

class RemoteTransportResultModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  RemoteTransportResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });

  factory RemoteTransportResultModel.fromJson(Map json) {
    return RemoteTransportResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      text: json['Text'],
      link: json['Link'],
    );
  }

  TransportResultEntity toEntity() => TransportResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        text: text,
        link: link,
      );
}
