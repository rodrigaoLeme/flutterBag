import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../data/models/food/remote_food_model.dart';
import '../../../data/models/food_internal/remote_food_internal_model.dart';
import '../../../domain/entities/food/food_entity.dart';
import '../../helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';
import '../dashboard/section_view_model.dart';

class FoodViewModel {
  List<ExternalFoodViewModel> externalFood;
  List<ExternalFoodViewModel> externalFoodFiltered;
  List<ExternalFoodViewModel> favoreitesExternalFiltered;
  List<ExternalFoodViewModel> favoreitesExternalFood;
  List<InternalFoodViewModel> internalFood;
  ValueNotifier<InternalFoodViewModel?> currentInternalFood =
      ValueNotifier(null);
  final SectionType? type;
  ExternalFoodFilter externalFoodFilter;
  bool isFavorite = false;

  FoodViewModel({
    required this.externalFood,
    required this.internalFood,
    required this.favoreitesExternalFood,
    required this.type,
    required this.externalFoodFilter,
  })  : externalFoodFiltered = externalFood,
        favoreitesExternalFiltered = favoreitesExternalFood;

  void setCurrentInternalFood(InternalFoodViewModel model) {
    currentInternalFood.value = model;
  }

  void clearFilter() {
    final List<TypeCuisine> filterType = externalFood
        .map((element) => TypeCuisine(type: element.typeCuisine ?? ''))
        .toSet()
        .toList();
    externalFoodFilter = ExternalFoodFilter(
        filterTypes: filterType,
        cousineFilterGroup: filterType
            .map(
              (element) => ExternalFoodFilterType(
                  type: ExternalFilterType.cousine,
                  description: element.type,
                  count: 1,
                  isSelected: false),
            )
            .toList());
    externalFoodFiltered = externalFood;
    favoreitesExternalFiltered = favoreitesExternalFood;
  }

  void setCurrentFilter(ExternalFoodFilter filter, bool isFavorite) {
    this.isFavorite = isFavorite;
    externalFoodFilter = filter;
    final cousineActive = filter.cousineFilterGroup
        .where((element) => element.isSelected)
        .toList();
    externalFoodFiltered = externalFood
        .where((element) => (cousineActive.isNotEmpty
            ? cousineActive.firstWhereOrNull(
                    (item) => item.description == element.typeCuisine) !=
                null
            : true))
        .toList();

    favoreitesExternalFiltered = favoreitesExternalFood
        .where((element) => (cousineActive.isNotEmpty
            ? cousineActive.firstWhereOrNull(
                    (item) => item.description == element.typeCuisine) !=
                null
            : true))
        .toList();

    if (filter.isVegan == true) {
      externalFoodFiltered = externalFoodFiltered
          .where((element) => element.isVegan == filter.isVegan)
          .toList();
      favoreitesExternalFiltered = favoreitesExternalFood
          .where((element) => element.isVegan == filter.isVegan)
          .toList();
    }
    if (filter.isSponsor == true) {
      externalFoodFiltered = externalFoodFiltered
          .where((element) => element.isSponsor == filter.isSponsor)
          .toList();
      favoreitesExternalFiltered = favoreitesExternalFood
          .where((element) => element.isSponsor == filter.isSponsor)
          .toList();
    }

    if (filter.isVegetarian == true) {
      externalFoodFiltered = externalFoodFiltered
          .where((element) => element.isVegetarian == filter.isVegetarian)
          .toList();

      favoreitesExternalFiltered = favoreitesExternalFood
          .where((element) => element.isVegetarian == filter.isVegetarian)
          .toList();
    }

    if (filter.withDiscount == true) {
      externalFoodFiltered = externalFoodFiltered
          .where((element) => filter.withDiscount == true
              ? (element.discount != null)
              : element.discount == null)
          .toList();
      favoreitesExternalFiltered = favoreitesExternalFood
          .where((element) => filter.withDiscount == true
              ? (element.discount != null)
              : element.discount == null)
          .toList();
    }
  }
}

class ExternalFoodViewModel {
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
  bool? isFavorite;
  final String? photoBackgroundColor;

  ExternalFoodViewModel({
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
    required this.isFavorite,
    required this.photoBackgroundColor,
  });

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

  void setIsFavorite() {
    isFavorite = !(isFavorite ?? false);
  }
}

class InternalFoodViewModel {
  final String? eventExternalId;
  final String? externalId;
  final String? day;
  final String? descriptionMenu;
  final String? purchaseLink;
  final String? date;

  InternalFoodViewModel({
    required this.eventExternalId,
    required this.externalId,
    required this.day,
    required this.descriptionMenu,
    required this.purchaseLink,
    required this.date,
  });

  String get filterDate {
    final DateTime? startDateTime = DateTime.tryParse(date ?? '');
    return startDateTime?.filterDate ?? '';
  }
}

class ExternalFoodListViewModelFactory {
  static Future<FoodViewModel> make({
    RemoteResultFoodModel? model,
    RemoteResultFoodInternalModel? internal,
    FoodResultEntity? favorites,
    SectionType? sectionType,
  }) async {
    List<ExternalFoodViewModel> foods = model?.foodExternal != null
        ? await Future.wait(
            model!.foodExternal!.map(
              (element) async => ExternalFoodViewModel(
                eventExternalId: element.eventExternalId,
                externalId: element.externalId,
                name: await element.name?.translate(),
                discount: element.discount,
                location: element.location,
                website: element.website,
                phone: element.phone,
                typeCuisine: element.typeCuisine,
                photoUrl: element.photoUrl,
                isSponsor: element.isSponsor,
                isVegan: element.isVegan,
                isVegetarian: element.isVegetarian,
                isFavorite: favorites?.foodExternal?.firstWhereOrNull(
                        (elementFavorite) =>
                            elementFavorite.externalId == element.externalId) !=
                    null,
                photoBackgroundColor: element.photoBackgroundColor,
              ),
            ),
          )
        : [];
    final foodInternal = internal?.foodInternal
        ?.where((element) =>
            element.descriptionMenu != null && element.descriptionMenu != '')
        .toList();

    final List<InternalFoodViewModel> internalFood = foodInternal != null
        ? await Future.wait(
            foodInternal.map(
              (element) async => InternalFoodViewModel(
                eventExternalId: element.eventExternalId,
                externalId: element.externalId,
                day: await element.day?.translate(),
                descriptionMenu: await element.descriptionMenu?.translate(),
                purchaseLink: element.purchaseLink,
                date: element.date,
              ),
            ),
          )
        : [];

    final favoritesFood = favorites?.foodExternal
            ?.map(
              (element) => ExternalFoodViewModel(
                eventExternalId: element.eventExternalId,
                externalId: element.externalId,
                name: element.name,
                discount: element.discount,
                location: element.location,
                website: element.website,
                phone: element.phone,
                typeCuisine: element.typeCuisine,
                photoUrl: element.photoUrl,
                isSponsor: element.isSponsor,
                isVegan: element.isVegan,
                isVegetarian: element.isVegetarian,
                isFavorite: true,
                photoBackgroundColor: element.photoBackgroundColor,
              ),
            )
            .toList() ??
        [];

    final List<TypeCuisine> filterType = foods
        .map((element) => TypeCuisine(type: element.typeCuisine ?? ''))
        .toSet()
        .toList();
    final externalFoodFilter = ExternalFoodFilter(
        filterTypes: filterType,
        cousineFilterGroup: filterType
            .map(
              (element) => ExternalFoodFilterType(
                  type: ExternalFilterType.cousine,
                  description: element.type,
                  count: 1,
                  isSelected: false),
            )
            .toList());

    return FoodViewModel(
      externalFood: foods,
      internalFood: internalFood,
      favoreitesExternalFood: favoritesFood,
      type: sectionType ?? SectionType.restaurantsInternal,
      externalFoodFilter: externalFoodFilter,
    );
  }
}

class ExternalFoodFilter {
  List<TypeCuisine> filterTypes;
  bool? isVegetarian;
  bool? isVegan;
  bool? withDiscount;
  bool? isSponsor;
  List<ExternalFoodFilterType> cousineFilterGroup;
  List<ExternalFoodFilterType> specialityFilterGroup = [];
  List<ExternalFoodFilterType> othersFilterGroup = [];
  List<ExternalFilterType> externalFilterType = ExternalFilterType.values;
  bool isFavorite = false;

  ExternalFoodFilter({
    this.filterTypes = const [],
    this.isVegetarian,
    this.isVegan,
    this.withDiscount,
    this.isSponsor,
    this.cousineFilterGroup = const [],
  }) {
    specialityFilterGroup = [
      ExternalFoodFilterType(
        type: ExternalFilterType.especiality,
        description: 'Vegetarian',
        count: 1,
        isSelected: isVegetarian ?? false,
      ),
      ExternalFoodFilterType(
        type: ExternalFilterType.especiality,
        description: 'Vegan',
        count: 1,
        isSelected: isVegan ?? false,
      )
    ];

    othersFilterGroup = [
      ExternalFoodFilterType(
        type: ExternalFilterType.others,
        description: 'Sponsor',
        count: 1,
        isSelected: isSponsor ?? false,
      ),
      ExternalFoodFilterType(
        type: ExternalFilterType.others,
        description: 'Coupon',
        count: 1,
        isSelected: withDiscount ?? false,
      ),
    ];
  }

  ExternalFoodFilter copyWith({
    List<TypeCuisine>? filterTypes,
    bool? isVegetarian,
    bool? isVegan,
    bool? withDiscount,
    bool? isSponsor,
    List<ExternalFoodFilterType>? cousineFilterGroup,
  }) {
    return ExternalFoodFilter(
      filterTypes: filterTypes ?? this.filterTypes,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      withDiscount: withDiscount ?? this.withDiscount,
      isSponsor: isSponsor ?? this.isSponsor,
      cousineFilterGroup: cousineFilterGroup ?? this.cousineFilterGroup,
    );
  }

  List<ExternalFoodFilterType> filterGroupByType(ExternalFilterType type) {
    switch (type) {
      case ExternalFilterType.cousine:
        return cousineFilterGroup;

      case ExternalFilterType.especiality:
        return specialityFilterGroup;

      case ExternalFilterType.others:
        return othersFilterGroup;
    }
  }

  void setIsActive(ExternalFilterType type, bool isActive, int index) {
    switch (type) {
      case ExternalFilterType.cousine:
        cousineFilterGroup[index].setCurrent();

      case ExternalFilterType.especiality:
        specialityFilterGroup[index].setCurrent();
        if (index == 0) {
          isVegetarian = isActive;
        } else {
          isVegan = isActive;
        }

      case ExternalFilterType.others:
        othersFilterGroup[index].setCurrent();
        if (index == 0) {
          isSponsor = isActive;
        } else {
          withDiscount = isActive;
        }
    }
  }

  List<ExternalFoodFilterType> get activeFilterGroup {
    return [
      ...cousineFilterGroup.where((element) => element.isSelected).toList(),
      ...specialityFilterGroup.where((element) => element.isSelected).toList(),
      ...othersFilterGroup.where((element) => element.isSelected).toList(),
    ];
  }
}

class ExternalFoodFilterType {
  final ExternalFilterType type;
  final String description;
  final int count;
  bool isSelected;

  ExternalFoodFilterType({
    required this.type,
    required this.description,
    required this.count,
    required this.isSelected,
  });

  void setCurrent() {
    isSelected = !isSelected;
  }

  void clearFilter() {
    isSelected = false;
  }
}

class TypeCuisine {
  final String type;

  TypeCuisine({
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeCuisine &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}

enum ExternalFilterType {
  cousine,
  especiality,
  others;

  String get title {
    switch (this) {
      case ExternalFilterType.cousine:
        return 'COUSINE';

      case ExternalFilterType.especiality:
        return 'Dietary Preferences';
      case ExternalFilterType.others:
        return 'OTHERS';
    }
  }
}
