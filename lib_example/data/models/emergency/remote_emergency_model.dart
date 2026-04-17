import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/emergency/emergency_entity.dart';
import '../../http/http.dart';

class RemoteEmergencyModel {
  final List<EmergencyResultModel>? result;

  RemoteEmergencyModel({
    required this.result,
  });

  factory RemoteEmergencyModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final result = decodedResult
          .map((item) =>
              EmergencyResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteEmergencyModel(result: result);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
  EmergencyEntity toEntity() => EmergencyEntity(
        result: result!
            .map<EmergencyResultEntity>((emergency) => emergency.toEntity())
            .toList(),
      );
}

class EmergencyResultModel {
  final int? id;
  final String? externalId;
  final int? eventId;
  final String? eventExternalId;
  final String? type;
  final String? title;
  final String? description;
  final String? information;
  final int? order;

  EmergencyResultModel({
    required this.id,
    required this.externalId,
    required this.eventId,
    required this.eventExternalId,
    required this.type,
    required this.title,
    required this.description,
    required this.information,
    required this.order,
  });

  factory EmergencyResultModel.fromJson(Map json) {
    if (!json.containsKey('Id')) {
      throw HttpError.invalidData;
    }

    return EmergencyResultModel(
      id: json['Id'],
      externalId: json['ExternalId'],
      eventId: json['EventId'],
      eventExternalId: json['EventExternalId'],
      type: json['Type'],
      title: json['Title'],
      description: json['Description'],
      information: json['Information'],
      order: json['Order'],
    );
  }

  EmergencyResultEntity toEntity() => EmergencyResultEntity(
        id: id,
        externalId: externalId,
        eventId: eventId,
        eventExternalId: eventExternalId,
        type: type,
        title: title,
        description: description,
        information: information,
        order: order,
      );
}

enum EmergencyTypeModel {
  phone('Phone'),
  link('Link'),
  text('Text'),
  location('AddressMap');

  const EmergencyTypeModel(this.type);
  final String type;

  String get iconAsset {
    switch (this) {
      case EmergencyTypeModel.phone:
        return 'lib/ui/assets/images/icon/phone-regular.svg';
      case EmergencyTypeModel.text:
        return 'lib/ui/assets/images/icon/message-text-regular.svg';
      case EmergencyTypeModel.link:
        return 'lib/ui/assets/images/icon/globe.svg';
      case EmergencyTypeModel.location:
        return 'lib/ui/assets/images/icon/location-dot-regular.svg';
    }
  }

  bool get isLink {
    switch (this) {
      case EmergencyTypeModel.link:
        return true;
      default:
        return false;
    }
  }

  static EmergencyTypeModel fromType(String? type) {
    return EmergencyTypeModel.values.firstWhere(
      (e) => e.type == type,
      orElse: () => EmergencyTypeModel.phone,
    );
  }
}
