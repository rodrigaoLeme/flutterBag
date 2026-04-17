class FoodInternalResultEntity {
  final List<FoodInternalEntity>? foodInternal;

  FoodInternalResultEntity({
    required this.foodInternal,
  });
}

class FoodInternalEntity {
  final String? eventExternalId;
  final String? externalId;
  final String? day;
  final String? descriptionMenu;
  final String? purchaseLink;
  final String? date;

  FoodInternalEntity({
    required this.eventExternalId,
    required this.externalId,
    required this.day,
    required this.descriptionMenu,
    required this.purchaseLink,
    required this.date,
  });
}
