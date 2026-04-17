import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteResultFoodModel {
  final List<RemoteFoodExternalModel>? foodExternal;

  RemoteResultFoodModel({
    required this.foodExternal,
  });

  factory RemoteResultFoodModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final foodExternal = decodedResult
          .map((item) =>
              RemoteFoodExternalModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteResultFoodModel(foodExternal: foodExternal);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  factory RemoteResultFoodModel.fromJson(Map json) {
    if (!json.containsKey('Result')) {
      throw HttpError.invalidData;
    }
    return RemoteResultFoodModel(
      foodExternal: json['Result']
          .map<RemoteFoodExternalModel>(
            (resultEventJson) =>
                RemoteFoodExternalModel.fromJson(resultEventJson),
          )
          .toList(),
    );
  }

  FoodResultEntity toEntity() => FoodResultEntity(
        foodExternal: foodExternal
            ?.map<FoodExternalEntity>((event) => event.toEntity())
            .toList(),
      );
}

class RemoteFoodExternalModel {
  final String? eventExternalId;
  final String? externalId;
  final String? name;
  final String? discount;
  final String? location;
  final String? website;
  final String? phone;
  final String? typeCuisine;
  final String? photoUrl;
  final bool? isSponsor;
  final bool? isVegan;
  final bool? isVegetarian;
  final String? photoBackgroundColor;

  RemoteFoodExternalModel(
      {required this.eventExternalId,
      required this.externalId,
      required this.name,
      required this.discount,
      required this.location,
      required this.website,
      required this.phone,
      required this.typeCuisine,
      required this.photoUrl,
      required this.isSponsor,
      required this.isVegan,
      required this.isVegetarian,
      required this.photoBackgroundColor});
  factory RemoteFoodExternalModel.fromJson(Map json) {
    if (!json.containsKey('EventExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteFoodExternalModel(
        eventExternalId: json['EventExternalId'],
        externalId: json['ExternalId'],
        name: json['Name'],
        discount: json['Discount'],
        location: json['Location'],
        website: json['Website'],
        phone: json['Phone'],
        typeCuisine: json['TypeCuisine'],
        photoUrl: json['PhotoUrl'],
        isSponsor: json['IsSponsor'],
        isVegan: json['IsVegan'],
        isVegetarian: json['IsVegetarian'],
        photoBackgroundColor: json['PhotoBackgroundColor']);
  }

  FoodExternalEntity toEntity() => FoodExternalEntity(
        eventExternalId: eventExternalId,
        externalId: externalId,
        name: name,
        discount: discount,
        location: location,
        website: website,
        phone: phone,
        typeCuisine: typeCuisine,
        photoUrl: photoUrl,
        isSponsor: isSponsor,
        isVegan: isVegan,
        isVegetarian: isVegetarian,
        photoBackgroundColor: photoBackgroundColor,
      );
}
