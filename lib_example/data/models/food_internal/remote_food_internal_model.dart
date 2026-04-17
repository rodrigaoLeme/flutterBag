import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/food_internal/food_internal_entity.dart';
import '../../http/http.dart';

class RemoteResultFoodInternalModel {
  final List<RemoteFoodInternalModel>? foodInternal;

  RemoteResultFoodInternalModel({
    required this.foodInternal,
  });

  factory RemoteResultFoodInternalModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final foodInternal = decodedResult
          .map((item) =>
              RemoteFoodInternalModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteResultFoodInternalModel(foodInternal: foodInternal);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
}

class RemoteFoodInternalModel {
  final String? eventExternalId;
  final String? externalId;
  final String? day;
  final String? descriptionMenu;
  final String? purchaseLink;
  final String? date;

  RemoteFoodInternalModel({
    required this.eventExternalId,
    required this.externalId,
    required this.day,
    required this.descriptionMenu,
    required this.purchaseLink,
    required this.date,
  });

  factory RemoteFoodInternalModel.fromJson(Map json) {
    if (!json.containsKey('EventExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteFoodInternalModel(
      eventExternalId: json['EventExternalId'],
      externalId: json['ExternalId'],
      day: json['Day'],
      descriptionMenu: json['DescriptionMenu'],
      purchaseLink: json['PurchaseLink'],
      date: json['Date'],
    );
  }

  FoodInternalEntity toEntity() => FoodInternalEntity(
        eventExternalId: eventExternalId,
        externalId: externalId,
        day: day,
        descriptionMenu: descriptionMenu,
        purchaseLink: purchaseLink,
        date: date,
      );
}
