import 'package:collection/collection.dart';

import '../../../data/models/exhibition/remote_exhibition_model.dart';
import '../../../domain/entities/entities.dart';
import '../../helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';

class ExhibitionsViewModel {
  final List<ExhibitionViewModel> exhibitions;
  List<ExhibitionViewModel> favoritesExhibition;
  List<ExhibitionViewModel> favoritesExhibitionFiltered = [];
  final List<ExhibitionGroup> exhibitionGroups;
  final List<ExhibitionGroup> exhibitionDivisionGroups;
  List<ExhibitionViewModel> filteredExhibitions = [];
  bool isSearching = false;
  String? lastedSearchText;

  ExhibitionsViewModel({
    required this.exhibitions,
    required this.favoritesExhibition,
    required this.exhibitionGroups,
    required this.exhibitionDivisionGroups,
  }) {
    filteredExhibitions = exhibitions;
    favoritesExhibitionFiltered = favoritesExhibition;
  }

  int get exhibitionCount {
    if (exhibitions.length <= 3) {
      return 1;
    }
    return (exhibitions.length / 3).floor();
  }

  void setCurrentFilter(ExhibitionGroup filter) {
    for (final item in exhibitionGroups) {
      if (item.type == filter.type) {
        item.setCurrent();
      }
    }
    if (selectedDivisionGroups.isEmpty) {
      clearFilter();
    } else {
      updateExhibitionsItens();
    }
    if (lastedSearchText != null) {
      filterBy(lastedSearchText!);
    }
  }

  void setCurrentDivisionFilter(ExhibitionGroup filter) {
    for (final item in exhibitionDivisionGroups) {
      if (item.type == filter.type) {
        item.setCurrent();
      }
    }
    updateExhibitionsItens();
  }

  void updateExhibitionsItens() {
    filteredExhibitions = exhibitions.where((element) {
      return selectedDivisionGroups.firstWhereOrNull(
            (group) {
              if (group.isDivision) {
                return selectedDivisionFilterGroups.firstWhereOrNull(
                        (elementGroup) =>
                            elementGroup.type == element.divisionAcronym) !=
                    null;
              }
              return group.type == element.type;
            },
          ) !=
          null;
    }).toList();

    favoritesExhibitionFiltered = favoritesExhibition.where((element) {
      return selectedDivisionGroups.firstWhereOrNull(
            (group) {
              if (group.isDivision) {
                return selectedDivisionFilterGroups.firstWhereOrNull(
                        (elementGroup) =>
                            elementGroup.type == element.divisionAcronym) !=
                    null;
              }
              return group.type == element.type;
            },
          ) !=
          null;
    }).toList();
  }

  bool get isDivisionFilterSelected {
    return exhibitionGroups.firstWhereOrNull(
            (element) => element.isDivision == true && element.isSelected) !=
        null;
  }

  void clearFilter() {
    for (final item in exhibitionGroups) {
      item.clearFilter();
    }
    filteredExhibitions = exhibitions;
    favoritesExhibitionFiltered = favoritesExhibition;
  }

  void filterBy(String text) {
    lastedSearchText = text.isNotEmpty ? text : null;
    isSearching = text.isNotEmpty;
    final currentFilter =
        exhibitionGroups.firstWhereOrNull((element) => element.isSelected);
    final query = text.toLowerCase();
    if (currentFilter != null) {
      filteredExhibitions = exhibitions
          .where(
            (element) =>
                element.type == currentFilter.type &&
                (element.description?.toLowerCase().contains(query) == true ||
                    element.division?.toLowerCase().contains(query) == true ||
                    element.name?.toLowerCase().contains(query) == true ||
                    element.location?.toLowerCase().contains(query) == true),
          )
          .toList();

      favoritesExhibitionFiltered = favoritesExhibition
          .where(
            (element) =>
                element.type == currentFilter.type &&
                (element.description?.toLowerCase().contains(query) == true ||
                    element.division?.toLowerCase().contains(query) == true ||
                    element.name?.toLowerCase().contains(query) == true ||
                    element.location?.toLowerCase().contains(query) == true),
          )
          .toList();
    } else {
      filteredExhibitions = exhibitions
          .where(
            (element) =>
                element.description?.toLowerCase().contains(query) == true ||
                element.division?.toLowerCase().contains(query) == true ||
                element.name?.toLowerCase().contains(query) == true ||
                element.location?.toLowerCase().contains(query) == true,
          )
          .toList();

      favoritesExhibitionFiltered = favoritesExhibition
          .where(
            (element) =>
                element.description?.toLowerCase().contains(query) == true ||
                element.division?.toLowerCase().contains(query) == true ||
                element.name?.toLowerCase().contains(query) == true ||
                element.location?.toLowerCase().contains(query) == true,
          )
          .toList();
    }
  }

  List<List<ExhibitionViewModel>> get homeSections {
    List<List<ExhibitionViewModel>> sections = [];
    for (int i = 0; i < exhibitions.length; i += 3) {
      sections.add(exhibitions.sublist(
          i, i + 3 > exhibitions.length ? exhibitions.length : i + 3));
    }
    return sections;
  }

  List<ExhibitionGroup> get selectedDivisionGroups {
    return exhibitionGroups.where((element) => element.isSelected).toList();
  }

  List<ExhibitionGroup> get selectedDivisionFilterGroups {
    return exhibitionDivisionGroups
        .where((element) => element.isSelected)
        .toList();
  }
}

class ExhibitionViewModel {
  final int? id;
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? description;
  final String? division;
  final String? divisionAcronym;
  final String? divisionName;
  final String? type;
  final String? location;
  final String? startTime;
  final String? finalTime;
  final String? timezone;
  final int? fileCount;
  final List<String>? social;
  final String? exhibitorPictureUrl;
  final bool? showTime;
  final List<FilesViewModel>? files;
  bool? isFavorite;
  final String? exhibitorPictureBackgroundColor;

  ExhibitionViewModel({
    required this.id,
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.description,
    required this.division,
    required this.divisionAcronym,
    required this.divisionName,
    required this.type,
    required this.location,
    required this.startTime,
    required this.finalTime,
    required this.timezone,
    required this.fileCount,
    required this.social,
    required this.exhibitorPictureUrl,
    required this.showTime,
    required this.files,
    required this.isFavorite,
    required this.exhibitorPictureBackgroundColor,
  });

  ExhibitionResultEntity toEntity() => ExhibitionResultEntity(
        id: id,
        eventExternalId: eventExternalId,
        externalId: externalId,
        name: name,
        description: description,
        division: division,
        divisionAcronym: divisionAcronym,
        divisionName: divisionName,
        type: type,
        location: location,
        startTime: startTime,
        finalTime: finalTime,
        timezone: timezone,
        fileCount: fileCount,
        social: social,
        exhibitorPictureUrl: exhibitorPictureUrl,
        showTime: showTime,
        files: files?.map<FilesEntity>((files) => files.toEntity()).toList(),
        exhibitorPictureBackgroundColor: exhibitorPictureBackgroundColor,
      );

  String get headerTitle {
    final DateTime? startDateTime = DateTime.tryParse(startTime ?? '');
    final DateTime? finalDateTime = DateTime.tryParse(finalTime ?? '');
    return '${startDateTime?.toFormattedTime} - ${finalDateTime?.toFormattedTime}';
  }

  void setIsFavorite() {
    isFavorite = !(isFavorite ?? false);
  }
}

class ExhibitionViewModelFactory {
  static Future<ExhibitionsViewModel> make({
    RemoteExhibitionModel? model,
    ExhibitionEntity? favorites,
  }) async {
    final List<ExhibitionViewModel> exhibitions = model?.exhibitor != null
        ? await Future.wait<ExhibitionViewModel>(
            model!.exhibitor!.map(
              (element) async => ExhibitionViewModel(
                id: element.id,
                externalId: element.externalId,
                eventExternalId: element.eventExternalId,
                name: await element.name?.translate(),
                description: await element.description?.translate(),
                division: await element.division?.translate(),
                divisionAcronym: element.divisionAcronym,
                divisionName: element.divisionName,
                type: element.type,
                location: element.location,
                startTime: element.startTime,
                finalTime: element.finalTime,
                timezone: element.timezone,
                fileCount: element.fileCount,
                social: element.social,
                exhibitorPictureUrl: element.exhibitorPictureUrl,
                showTime: element.showTime,
                files: element.files != null
                    ? await Future.wait(
                        element.files!.map(
                          (file) async => FilesViewModel(
                            externalId: file.externalId,
                            name: await file.name?.translate(),
                            storagePath: file.storagePath,
                            exhibitionType:
                                ExhibitionTypeModel.fromType(element.type),
                          ),
                        ),
                      )
                    : [],
                isFavorite: favorites?.exhibitor?.firstWhereOrNull(
                        (elementFavorite) =>
                            elementFavorite.externalId == element.externalId) !=
                    null,
                exhibitorPictureBackgroundColor:
                    element.exhibitorPictureBackgroundColor,
              ),
            ),
          )
        : [];

    final favoritesId = favorites?.exhibitor?.map((n) => n.externalId).toSet();
    final exhibitorsFavorites = model?.exhibitor
        ?.where((element) => favoritesId?.contains(element.externalId) == true)
        .toList();
    final List<ExhibitionViewModel> favoritesExhibitor =
        exhibitorsFavorites != null
            ? await Future.wait(
                exhibitorsFavorites.map(
                  (element) async => ExhibitionViewModel(
                    id: element.id,
                    externalId: element.externalId,
                    eventExternalId: element.eventExternalId,
                    name: element.name,
                    description: element.description,
                    division: element.division,
                    divisionAcronym: element.divisionAcronym,
                    divisionName: element.divisionName,
                    type: element.type,
                    location: element.location,
                    startTime: element.startTime,
                    finalTime: element.finalTime,
                    timezone: element.timezone,
                    fileCount: element.fileCount,
                    social: element.social,
                    exhibitorPictureUrl: element.exhibitorPictureUrl,
                    showTime: element.showTime,
                    files: element.files != null
                        ? await Future.wait(
                            element.files!.map(
                              (file) async => FilesViewModel(
                                externalId: file.externalId,
                                name: await file.name?.translate(),
                                storagePath: file.storagePath,
                                exhibitionType:
                                    ExhibitionTypeModel.fromType(element.type),
                              ),
                            ),
                          )
                        : [],
                    isFavorite: true,
                    exhibitorPictureBackgroundColor:
                        element.exhibitorPictureBackgroundColor,
                  ),
                ),
              )
            : [];

    final Map<String, int> exhibitionCounts = {};
    for (var item in exhibitions) {
      final key = item.type ?? '';
      exhibitionCounts[key] = (exhibitionCounts[key] ?? 0) + 1;
    }
    final Map<String, int> exhibitionDivisionCounts = {};
    for (var item in exhibitions) {
      final key = item.divisionAcronym ?? '';
      exhibitionDivisionCounts[key] = (exhibitionDivisionCounts[key] ?? 0) + 1;
    }

    final exhibitionGroups = exhibitionCounts.entries
        .map(
          (entry) => ExhibitionGroup(
              type: entry.key,
              count: entry.value,
              description: exhibitions
                      .firstWhereOrNull((element) => element.type == entry.key)
                      ?.type ??
                  '',
              isSelected: false,
              isDivision: entry.key == 'Division'),
        )
        .toList();

    final exhibitionDivisionGroups = exhibitionDivisionCounts.entries
        .map(
          (entry) => ExhibitionGroup(
            type: entry.key,
            count: entry.value,
            description: exhibitions
                    .firstWhereOrNull(
                        (element) => element.divisionAcronym == entry.key)
                    ?.divisionAcronym ??
                '',
            isSelected: false,
            isDivision: true,
          ),
        )
        .toList();

    return ExhibitionsViewModel(
      exhibitions: exhibitions,
      favoritesExhibition: favoritesExhibitor,
      exhibitionGroups: exhibitionGroups,
      exhibitionDivisionGroups: exhibitionDivisionGroups,
    );
  }
}

class FilesViewModel {
  final String? externalId;
  final String? name;
  final String? storagePath;
  final ExhibitionTypeModel exhibitionType;

  FilesViewModel({
    required this.externalId,
    required this.name,
    required this.storagePath,
    required this.exhibitionType,
  });

  String get iconUrl => exhibitionType.iconAsset;

  FilesEntity toEntity() => FilesEntity(
        externalId: externalId,
        name: name,
        storagePath: storagePath,
      );
}

class ExhibitionGroup {
  final String type;
  final String description;
  final int count;
  bool isSelected;
  bool isDivision;

  ExhibitionGroup({
    required this.type,
    required this.description,
    required this.count,
    required this.isSelected,
    required this.isDivision,
  });

  void setCurrent() {
    isSelected = !isSelected;
  }

  void clearFilter() {
    isSelected = false;
  }
}
