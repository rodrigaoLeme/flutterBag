import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteChooseEventModel {
  final List<ChooseEventResultModel> result;

  RemoteChooseEventModel({
    required this.result,
  });

  factory RemoteChooseEventModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final result = decodedResult
          .map((item) =>
              ChooseEventResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteChooseEventModel(result: result);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  ChooseEventEntity toEntity() => ChooseEventEntity(
        result: result
            .map<ChooseEventResultEntity>((event) => event.toEntity())
            .toList(),
      );
}

class ChooseEventResultModel {
  final String? externalId;
  final String? name;
  final String? timezone;
  final String? startDate;
  final String? address;
  final String? eventLogo;
  final String? eventColor;

  ChooseEventResultModel({
    required this.externalId,
    required this.name,
    required this.timezone,
    required this.startDate,
    required this.address,
    required this.eventLogo,
    required this.eventColor,
  });

  factory ChooseEventResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }

    return ChooseEventResultModel(
      externalId: json['ExternalId'],
      name: json['Name'],
      timezone: json['Timezone'],
      startDate: json['StartDate'],
      address: json['Address'],
      eventLogo: json['EventLogo'],
      eventColor: json['EventColor'],
    );
  }

  ChooseEventResultEntity toEntity() => ChooseEventResultEntity(
        externalId: externalId,
        name: name,
        timezone: timezone,
        startDate: startDate,
        address: address,
        eventLogo: eventLogo,
        eventColor: eventColor,
      );
}
