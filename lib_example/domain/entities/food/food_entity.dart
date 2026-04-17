class FoodResultEntity {
  final List<FoodExternalEntity>? foodExternal;

  FoodResultEntity({
    required this.foodExternal,
  });

  Map toJson() => {
        'Result': foodExternal?.map((element) => element.toMap()).toList(),
      };
}

class FoodExternalEntity {
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

  FoodExternalEntity({
    required this.eventExternalId,
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
    required this.photoBackgroundColor,
  });

  Map toMap() => {
        'ExternalId': externalId,
        'EventExternalId': eventExternalId,
        'Name': name,
        'Discount': discount,
        'Location': location,
        'Website': website,
        'Phone': phone,
        'TypeCuisine': typeCuisine,
        'PhotoUrl': photoUrl,
        'IsSponsor': isSponsor,
        'IsVegan': isVegan,
        'IsVegetarian': isVegetarian,
        'PhotoBackgroundColor': photoBackgroundColor,
      };
}
