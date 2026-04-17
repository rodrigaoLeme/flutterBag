import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../../data/models/agenda/remote_agenda_model.dart';
import '../../../data/models/exhibition/remote_exhibition_model.dart';
import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../domain/entities/exhibition/exhibition_entity.dart';
import '../../helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/i18n/resources.dart';
import '../event_details/event_details_view_model.dart';
import '../exhibition/exhibition_view_model.dart';

class AgendaViewModel {
  final List<ScheduleViewModel>? schedule;
  List<ScheduleTabs> tabs;
  final List<ScheduleFilter> filters;
  List<ScheduleFilter> favoriteFilter;
  ScheduleFilter? currentFilter;

  AgendaViewModel({
    required this.schedule,
    required this.tabs,
    required this.filters,
    required this.favoriteFilter,
    required this.currentFilter,
  });

  void setCurrentFilter(ScheduleFilter? filter) {
    currentFilter = filter;
    for (final currentTab in tabs) {
      for (final currentSection in currentTab.originalItens) {
        for (final currentItem in currentSection.itens) {
          currentItem.setupFilter(filter);
        }
      }
      currentTab.setupFilter(filter);
    }
  }

  bool get showHomeCards {
    return tabs
            .firstWhereOrNull((element) => element.currentSection != null)
            ?.currentSection
            ?.itens
            .isEmpty ==
        false;
  }

  double get homeCardsHeight {
    return 400.0;
  }

  ScheduleViewModel? get nextLive {
    final now = DateTime.now();
    final todayEvents = schedule?.where((event) {
      final start = DateTime.tryParse(event.startTime ?? '');
      return start != null &&
          DateFormat('yyyy-MM-dd').format(start) ==
              DateFormat('yyyy-MM-dd').format(now);
    }).toList();

    if (todayEvents?.isEmpty == true) return null;

    todayEvents
        ?.sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));

    ScheduleViewModel? nextEvent;

    for (int i = 0; i < (todayEvents?.length ?? 0); i++) {
      final start = DateTime.tryParse(todayEvents?[i].startTime ?? '');
      final end = DateTime.tryParse(todayEvents?[i].finalTime ?? '');

      if (start != null && end != null) {
        if (now.isAfter(start) && now.isBefore(end)) {
          nextEvent = ((i + 1) < (todayEvents?.length ?? 0))
              ? todayEvents![i + 1]
              : null;
          break;
        } else if (now.isBefore(start)) {
          nextEvent = todayEvents?[i];
          break;
        }
      }
    }
    return nextEvent;
  }

  Future setAsFavorite(
    ScheduleViewModel item,
    AgendaEntity? entity,
    AgendaEntity? favorites,
  ) async {
    for (ScheduleViewModel scheduleViewModel in schedule ?? []) {
      if (scheduleViewModel.externalId == item.externalId) {
        scheduleViewModel.setFavorite(!(item.isFavorite ?? false));
      }
    }
    tabs = await make(entity: entity, favorites: favorites);
  }

  Future<List<ScheduleTabs>> make({
    required AgendaEntity? entity,
    AgendaEntity? favorites,
  }) async {
    List<ScheduleTabs> newTabs = [];
    if (tabs.isNotEmpty) {
      if (tabs.length == 2) {
        final schedule = await ScheduleViewModelFactory.translateData(
          entity?.schedule,
          favorites,
          false,
        );
        final scheduleFavorite = await ScheduleViewModelFactory.translateData(
          favorites?.schedule ?? [],
          favorites,
          true,
        );

        favoriteFilter = ScheduleViewModelFactory.makeFilters(scheduleFavorite);
        final originalItens = ScheduleViewModelFactory.makeSection(
          schedule,
        );
        final favoritesOriginalItens = ScheduleViewModelFactory.makeSection(
          scheduleFavorite,
        );

        final scheduleTab = tabs.first;
        newTabs.add(
          ScheduleTabs(
            title: scheduleTab.title,
            filterTitle: scheduleTab.filterTitle,
            originalItens: originalItens,
            currentSection: scheduleTab.currentSection,
            filter: scheduleTab.filter,
          ),
        );

        final myScheduleTab = tabs.last;
        newTabs.add(
          ScheduleTabs(
            title: myScheduleTab.title,
            filterTitle: myScheduleTab.filterTitle,
            originalItens: favoritesOriginalItens,
            currentSection: myScheduleTab.currentSection,
            filter: myScheduleTab.filter,
          ),
        );
      }
    }
    return newTabs;
  }
}

class ScheduleViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? description;
  final String? location;
  final String? translationChannel;
  final String? timezone;
  final String? startTime;
  final String? finalTime;
  final String? type;
  final int? group;
  final String? groupName;
  bool? isFavorite;
  final List<SpeakersViewModel>? speakers;
  final ResourcesTypeModel resourcesType;
  final List<FilesViewModel>? files;

  ScheduleViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.description,
    required this.location,
    required this.translationChannel,
    required this.timezone,
    required this.startTime,
    required this.finalTime,
    required this.type,
    required this.group,
    required this.groupName,
    required this.isFavorite,
    required this.speakers,
    required this.resourcesType,
    required this.files,
  });

  String get iconUrl => resourcesType.iconAsset;

  EventScheduleResultEntity toEntity() => EventScheduleResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        name: name,
        description: description,
        location: location,
        translationChannel: translationChannel,
        timezone: timezone,
        startTime: startTime,
        finalTime: finalTime,
        type: type,
        group: group,
        groupName: groupName,
        speakers: speakers?.map((toElement) => toElement.toEntity()).toList(),
        files: files?.map<FilesEntity>((files) => files.toEntity()).toList(),
      );

  ScheduleType? get scheduleType {
    return ScheduleType.values.firstWhere((element) => element.value == type,
        orElse: () => ScheduleType.none);
  }

  String get headerTitle {
    final DateTime? startDateTime = DateTime.tryParse(startTime ?? '');
    final DateTime? finalDateTime = DateTime.tryParse(finalTime ?? '');
    return '${startDateTime?.toFormattedTime} - ${finalDateTime?.toFormattedTime}';
  }

  String get headerTitleDetails {
    final DateTime? startDateTime = DateTime.tryParse(startTime ?? '');
    final DateTime? finalDateTime = DateTime.tryParse(finalTime ?? '');
    return '${startDateTime?.dateDayAndMonthName} ${startDateTime?.toFormattedTime} - ${finalDateTime?.toFormattedTime}';
  }

  void setFavorite(bool value) {
    isFavorite = value;
  }
}

class ScheduleViewModelFactory {
  static Future<AgendaViewModel> make({
    required AgendaEntity? entity,
    AgendaEntity? favorites,
    ScheduleFilter? currentFilter,
  }) async {
    final schedule = await ScheduleViewModelFactory.translateData(
      entity?.schedule,
      favorites,
      false,
    );
    final scheduleFavorite = await ScheduleViewModelFactory.translateData(
      favorites?.schedule ?? [],
      favorites,
      true,
    );
    final filters = ScheduleViewModelFactory.makeFilters(schedule);
    final originalItens = ScheduleViewModelFactory.makeSection(
      schedule,
    );
    final favoriteFilters =
        ScheduleViewModelFactory.makeFilters(scheduleFavorite);
    final favoritesOriginalItens = ScheduleViewModelFactory.makeSection(
      scheduleFavorite,
    );
    final originalFilter = originalItens
        .where((element) => element.headerTitle == DateTime.now().filterDate)
        .toList();
    final favoritesOriginalItemsFavorite = favoritesOriginalItens
        .where((element) => element.headerTitle == DateTime.now().filterDate)
        .toList();
    return AgendaViewModel(
      schedule: schedule,
      tabs: [
        ScheduleTabs(
          title: R.string.scheduleLabel,
          filterTitle: R.string.allTinyLabel,
          originalItens: originalItens,
          currentSection:
              ScheduleViewModelFactory.makeCurrendSchedule(originalItens),
          filter: originalFilter.isNotEmpty ? originalFilter : originalItens,
        ),
        ScheduleTabs(
          title: R.string.mySchedule,
          filterTitle: R.string.myScheduleTiny,
          originalItens: favoritesOriginalItens,
          currentSection: ScheduleViewModelFactory.makeCurrendSchedule(
              favoritesOriginalItens, true),
          filter: favoritesOriginalItemsFavorite.isNotEmpty
              ? favoritesOriginalItemsFavorite
              : favoritesOriginalItens,
        ),
      ],
      filters: filters,
      favoriteFilter: favoriteFilters,
      currentFilter: currentFilter ??
          (filters.firstWhereOrNull(
                  (element) => element.date == DateTime.now().dayToStringEn) ??
              (filters.isEmpty ? null : filters.first)),
    );
  }

  static List<ScheduleSectionViewModel> makeSection(
    List<ScheduleViewModel> model,
  ) {
    final Map<String, List<ScheduleViewModel>> groupedByDate = {};
    for (final schedule in model) {
      if (schedule.startTime != null) {
        final String date =
            DateTime.tryParse(schedule.startTime ?? '')?.dayToStringEn ?? '';

        if (!groupedByDate.containsKey(date)) {
          groupedByDate[date] = [];
        }
        groupedByDate[date]!.add(schedule);
      }
    }

    final List<ScheduleItemViewModel> scheduleItems =
        groupedByDate.entries.map((entry) {
      return ScheduleItemViewModel(
        title: entry.key,
        originalItems: entry.value,
      );
    }).toList();

    scheduleItems.sort(
      (a, b) => a.title.compareTo(b.title),
    );
    List<ScheduleSectionViewModel> scheduleItemsSection = [];

    for (final schedule in scheduleItems) {
      final Map<int, List<ScheduleViewModel>> groupedItemDate = {};
      List<ScheduleItemViewModel> itens = [];
      for (var item in schedule.originalItems) {
        if (item.group != null) {
          final date = item.group ?? 0;

          if (!groupedItemDate.containsKey(date)) {
            groupedItemDate[date] = [];
          }
          groupedItemDate[date]?.add(item);
        }
      }
      itens = groupedItemDate.entries.map(
        (entry) {
          return ScheduleItemViewModel(
            title: schedule.originalItems
                    .firstWhereOrNull((element) => element.group == entry.key)
                    ?.groupName ??
                '',
            originalItems: schedule.originalItems
                .where((element) => element.group == entry.key)
                .toList(),
          );
        },
      ).toList();
      scheduleItemsSection.add(
        ScheduleSectionViewModel(
          title: schedule.title,
          itens: itens,
        ),
      );
    }
    return scheduleItemsSection;
  }

  static ScheduleSectionViewModel? makeCurrendSchedule(
      List<ScheduleSectionViewModel> sections,
      [bool isFavorite = false]) {
    DateTime now = DateTime.now();

    ScheduleSectionViewModel? currentItem = sections
        .firstWhereOrNull((element) => element.title == now.dayToStringEn);
    if (!isFavorite) {
      final todayMidnight = DateTime(now.year, now.month, now.day);

      currentItem ??= sections.firstWhereOrNull((element) {
        DateTime? startDate = DateTime.tryParse(element.title);
        if (startDate == null) {
          return false;
        }

        return todayMidnight.isBefore(startDate);
      });
      currentItem ??= sections.lastWhereOrNull((element) {
        DateTime? startDate = DateTime.tryParse(element.title);
        if (startDate == null) {
          return false;
        }

        return todayMidnight.isAfter(startDate);
      });
    } else {
      currentItem ??= sections.isNotEmpty ? sections.first : null;
    }
    return currentItem;
  }

  static List<ScheduleFilter> makeFilters(List<ScheduleViewModel>? schedule) {
    if (schedule == null) return [];

    final Set<String> uniqueDates = {};

    for (final item in schedule) {
      if (item.startTime != null) {
        final DateTime? dateTime = DateTime.tryParse(item.startTime ?? '');
        final date = dateTime?.dayToStringEn ?? '';
        uniqueDates.add(date);
      }
    }

    List<ScheduleFilter> filters = [
      ...uniqueDates.map((date) {
        return ScheduleFilter(date: date);
      }).toList()
    ];

    filters.sort((a, b) => a.date.compareTo(b.date));
    if (filters.isNotEmpty) {
      filters.insert(
        0,
        ScheduleFilter(
          date: R.string.allLabel,
          isShowAllItems: true,
        ),
      );
    }
    return filters;
  }

  static Future<List<ScheduleViewModel>> translateData(
      List<EventScheduleResultEntity>? schedules,
      AgendaEntity? favorites,
      bool isFavorites) async {
    final List<ScheduleViewModel> schedule = schedules != null
        ? await Future.wait(
            schedules.map(
              (element) async => ScheduleViewModel(
                externalId: element.externalId,
                eventExternalId: element.eventExternalId,
                name: await element.name?.translate(),
                description: await element.description?.translate(),
                location: element.location,
                translationChannel: element.translationChannel,
                timezone: element.timezone,
                startTime: element.startTime,
                finalTime: element.finalTime,
                type: element.type,
                group: element.group,
                groupName: element.groupName,
                isFavorite: isFavorites
                    ? isFavorites
                    : favorites?.schedule?.firstWhereOrNull((elementFavorite) =>
                            elementFavorite.externalId == element.externalId) !=
                        null,
                speakers: element.speakers != null
                    ? await Future.wait(
                        element.speakers!.map(
                          (toElement) async => SpeakersViewModel(
                            id: toElement.id,
                            externalId: toElement.externalId,
                            fullName: toElement.fullName,
                            jobTitle: await toElement.jobTitle?.translate(),
                            biography: await toElement.biography?.translate(),
                            photoUrl: toElement.photoUrl,
                            division: await toElement.division?.translate(),
                            social: toElement.social,
                            photoBackgroundColor:
                                toElement.photoBackgroundColor,
                          ),
                        ),
                      )
                    : [],
                resourcesType: ResourcesTypeModel.fromType(element.type),
                files: element.files != null
                    ? await Future.wait(
                        element.files!.map(
                          (file) async => FilesViewModel(
                            externalId: file.externalId,
                            name: await file.name?.translate(),
                            storagePath: file.storagePath,
                            exhibitionType: ExhibitionTypeModel.fromType(
                                file.name?.getExtensionFile.toUpperCase()),
                          ),
                        ),
                      )
                    : [],
              ),
            ),
          )
        : [];

    return schedule;
  }
}

class ScheduleItemViewModel {
  final String title;
  final List<ScheduleViewModel> originalItems;
  List<ScheduleViewModel> filter;

  ScheduleItemViewModel({
    required this.title,
    required this.originalItems,
  }) : filter = originalItems;

  bool get showLiveBadge {
    return filter.firstWhereOrNull((element) {
          DateTime now = DateTime.now();
          DateTime? startDate = element.startTime?.parseDateWithTimezone(
              timezoneOffsetStr: element.timezone ?? now.timeZoneName);
          DateTime? endDate = element.finalTime?.parseDateWithTimezone(
              timezoneOffsetStr: element.timezone ?? now.timeZoneName);
          if (startDate == null || endDate == null) {
            return false;
          }

          return now.isAfter(startDate) && now.isBefore(endDate);
        }) !=
        null;
  }

  void setupFilter(ScheduleFilter? applyFilter) {
    if (applyFilter?.isShowAllItems == true) {
      filter = originalItems;
    } else {
      filter = originalItems.where((element) {
        final DateTime? dateTime = DateTime.tryParse(element.startTime ?? '');
        final date = dateTime?.dayToStringEn ?? '';
        return date == applyFilter?.date;
      }).toList();
    }
  }
}

class ScheduleSectionViewModel {
  final String title;
  final List<ScheduleItemViewModel> itens;

  ScheduleSectionViewModel({
    required this.title,
    required this.itens,
  });

  String get headerTitle {
    final DateTime? startDateTime = DateTime.tryParse(title);

    return startDateTime?.filterDate ?? '';
  }

  int get currentIndex {
    final DateTime now = DateTime.now();
    ScheduleItemViewModel? closestLiveItem;
    Duration? smallestDiff;

    for (final item in itens) {
      if (!item.showLiveBadge) continue;

      for (final event in item.filter) {
        final startDate = event.startTime?.parseDateWithTimezone(
            timezoneOffsetStr: event.timezone ?? now.timeZoneName);

        if (startDate != null && now.isAfter(startDate)) {
          final diff = now.difference(startDate).abs();

          if (smallestDiff == null || diff < smallestDiff) {
            smallestDiff = diff;
            closestLiveItem = item;
          }
        }
      }
    }

    if (closestLiveItem != null) {
      return itens.indexOf(closestLiveItem);
    }

    return 0;
  }
}

class ScheduleTabs {
  final String title;
  final String filterTitle;
  final List<ScheduleSectionViewModel> originalItens;
  List<ScheduleSectionViewModel> filter;
  final ScheduleSectionViewModel? currentSection;

  ScheduleTabs({
    required this.title,
    required this.filterTitle,
    required this.originalItens,
    required this.currentSection,
    required this.filter,
  });

  void setupFilter(ScheduleFilter? applyFilter) {
    if (applyFilter?.isShowAllItems == true) {
      filter = originalItens;
    } else {
      filter = originalItens.where((element) {
        return element.itens
            .where((elementItem) => elementItem.filter.isNotEmpty)
            .isNotEmpty;
      }).toList();
    }
  }

  String get globalKey {
    for (var element in filter) {
      final item = element.itens.firstWhereOrNull((item) => item.showLiveBadge);
      if (item != null) {
        return item.title;
      }
    }
    return '';
  }
}

enum ScheduleType {
  worship('WORSHIP'),
  musical('MUSIC'),
  business('BUSINESS'),
  prayer('PRAYER'),
  meals('MEALS'),
  registration('REGISTRATION'),
  exhibits('EXHIBITS'),
  specialMinistries('SPECIALMINISTRIES'),
  other('OTHER'),
  none('');

  const ScheduleType(this.value);
  final String value;

  String get icon {
    switch (this) {
      case ScheduleType.worship:
        return 'lib/ui/assets/images/icon/book-bible-light.svg';
      case ScheduleType.prayer:
        return 'lib/ui/assets/images/icon/person-praying-light.svg';
      case ScheduleType.musical:
        return 'lib/ui/assets/images/icon/music-light.svg';
      case ScheduleType.business:
        return 'lib/ui/assets/images/icon/check-to-slot-light.svg';
      case ScheduleType.meals:
        return 'lib/ui/assets/images/icon/fork-knife-light.svg';
      case ScheduleType.registration:
        return 'lib/ui/assets/images/icon/id-badge-regular.svg';
      case ScheduleType.exhibits:
        return 'lib/ui/assets/images/icon/tent-double-peak-regular.svg';
      case ScheduleType.specialMinistries:
        return 'lib/ui/assets/images/icon/hands-praying-light.svg';
      case ScheduleType.other:
        return 'lib/ui/assets/images/icon/circle-ellipsis-light.svg';
      default:
        return '';
    }
  }
}

class ScheduleFilter {
  final String date;
  final bool isShowAllItems;

  ScheduleFilter({
    required this.date,
    this.isShowAllItems = false,
  });

  String get filter {
    if (isShowAllItems) {
      return date;
    }
    final DateTime? dateTime = DateTime.tryParse(date);
    return dateTime?.filterDate ?? ''.toUpperCase();
  }
}

class SchedulePageNavigationData {
  final int currentIndex;
  final bool shouldPresentArrowBack;

  SchedulePageNavigationData({
    required this.currentIndex,
    required this.shouldPresentArrowBack,
  });
}
