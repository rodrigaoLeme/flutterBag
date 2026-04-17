import 'package:collection/collection.dart';

import '../../../data/models/spiritual/remote_spiritual_model.dart';
import '../../../domain/entities/spiritual/spiritual_entity.dart';
import '../../helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';
import '../event_details/event_details_view_model.dart';
import 'music_view_model.dart';

class SpiritualViewModel {
  final List<SpiritualResultViewModel> devotional;
  final List<MusicViewModel>? music;
  PrayerRoomViewModel? prayerRoom;
  DevotionalTabViewModel? morningDevotional;
  DevotionalTabViewModel? afternoonDevotional;
  DevotionalTabViewModel? eveningDevotional;
  List<MusicViewModel>? musicFiltered;

  SpiritualViewModel({
    required this.devotional,
    required this.music,
    required this.prayerRoom,
  }) {
    musicFiltered = music;
    _setupDevotional();
  }

  _setupDevotional() {
    final morningDevotionalList = devotional
        .where(
            (element) => element.dayPeriodType == DevotionalDayPeriod.morning)
        .toList();
    morningDevotional = DevotionalTabViewModel(
      devotional: morningDevotionalList,
      filters: morningDevotionalList
          .map(
            (toElement) => DevotionalFilter(
              date: toElement.selectedDay ?? '',
            ),
          )
          .toList(),
    );

    final afternoonDevotionalList = devotional
        .where(
            (element) => element.dayPeriodType == DevotionalDayPeriod.afternoon)
        .toList();

    afternoonDevotional = DevotionalTabViewModel(
      devotional: afternoonDevotionalList,
      filters: afternoonDevotionalList
          .map(
            (toElement) => DevotionalFilter(
              date: toElement.selectedDay ?? '',
            ),
          )
          .toList(),
    );
    final eveningDevotionalList = devotional
        .where(
            (element) => element.dayPeriodType == DevotionalDayPeriod.evening)
        .toList();

    eveningDevotional = DevotionalTabViewModel(
      devotional: eveningDevotionalList,
      filters: eveningDevotionalList
          .map(
            (toElement) => DevotionalFilter(
              date: toElement.selectedDay ?? '',
            ),
          )
          .toList(),
    );
  }

  void filterBy(String text) {
    if (text.trim().isEmpty) {
      musicFiltered = music;
    } else {
      final query = text.toLowerCase();
      musicFiltered = music
          ?.where(
            (element) =>
                element.name?.toLowerCase().contains(query) == true ||
                element.text?.toLowerCase().contains(query) == true,
          )
          .toList();
    }
  }

  setupInitialFilter(DevotionalFilter filter, DevotionalDayPeriod type) {
    switch (type) {
      case DevotionalDayPeriod.morning:
        morningDevotional?.setCurrentFilter(filter: filter);
      case DevotionalDayPeriod.afternoon:
        afternoonDevotional?.setCurrentFilter(filter: filter);
      case DevotionalDayPeriod.evening:
        eveningDevotional?.setCurrentFilter(filter: filter);
    }
  }

  setCurrentLanguageFilter(
      DevotionalLanguages filter, DevotionalDayPeriod type) {
    switch (type) {
      case DevotionalDayPeriod.morning:
        morningDevotional?.setCurrentLanguageFilter(filter: filter);
      case DevotionalDayPeriod.afternoon:
        afternoonDevotional?.setCurrentLanguageFilter(filter: filter);
      case DevotionalDayPeriod.evening:
        eveningDevotional?.setCurrentLanguageFilter(filter: filter);
    }
  }
}

class SpiritualResultViewModel {
  final int? id;
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? photoUrl;
  final String? dayPeriod;
  final String? selectedDay;
  final int? devotionalsCount;
  final int? speakersCount;
  final List<SpeakersViewModel>? speakers;
  final List<DevotionalsViewModel>? devotionals;
  List<DevotionalLanguages> languages = [];
  DevotionalLanguages? currentLanguageFilter;

  SpiritualResultViewModel({
    required this.id,
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.photoUrl,
    required this.dayPeriod,
    required this.selectedDay,
    required this.devotionalsCount,
    required this.speakersCount,
    required this.speakers,
    required this.devotionals,
  }) {
    _setupInitialFilter();
  }

  _setupInitialFilter() {
    currentLanguageFilter = devotionals?.isEmpty == true
        ? null
        : DevotionalLanguages(language: devotionals?[0].language ?? '');
    languages = devotionals?.isEmpty == true
        ? []
        : devotionals
                ?.map((elementD) =>
                    DevotionalLanguages(language: elementD.language ?? ''))
                .toList() ??
            [];
  }

  DevotionalDayPeriod get dayPeriodType {
    return DevotionalDayPeriod.values
        .firstWhere((element) => element.value == dayPeriod);
  }

  DevotionalsViewModel? get linkByLanguage {
    return devotionals?.firstWhereOrNull(
        (element) => element.language == currentLanguageFilter?.language);
  }

  void setCurrentLanguageFilter({required DevotionalLanguages filter}) {
    currentLanguageFilter = filter;
  }
}

class SpiritualViewModelFactory {
  static Future<SpiritualViewModel> make(RemoteSpiritualModel model) async {
    return SpiritualViewModel(
      devotional: model.devotional != null
          ? await Future.wait<SpiritualResultViewModel>(
              model.devotional!.map(
                (element) async => SpiritualResultViewModel(
                  id: element.id,
                  externalId: element.externalId,
                  eventExternalId: element.eventExternalId,
                  title: await element.title?.translate(),
                  photoUrl: element.photoUrl,
                  dayPeriod: element.dayPeriod,
                  selectedDay: element.selectedDay,
                  devotionalsCount: element.devotionalsCount,
                  speakersCount: element.speakersCount,
                  speakers: element.speakers != null
                      ? await Future.wait(
                          element.speakers!.map(
                            (speaker) async => SpeakersViewModel(
                              externalId: speaker.externalId,
                              fullName: await speaker.fullName?.translate(),
                              jobTitle: await speaker.jobTitle?.translate(),
                              biography: await speaker.biography?.translate(),
                              photoUrl: speaker.photoUrl,
                              division: speaker.division,
                              id: speaker.id,
                              social: speaker.social,
                              photoBackgroundColor:
                                  speaker.photoBackgroundColor,
                            ),
                          ),
                        )
                      : [],
                  devotionals: element.devotionals != null
                      ? await Future.wait(
                          element.devotionals!.map(
                            (devotional) async => DevotionalsViewModel(
                              language: devotional.language,
                              link: devotional.link,
                              order: devotional.order,
                              isDefault: devotional.isDefault,
                            ),
                          ),
                        )
                      : [],
                ),
              ),
            )
          : [],
      music: model.music != null
          ? await Future.wait(
              model.music!.map(
                (music) async => MusicViewModel(
                  externalId: music.externalId,
                  eventExternalId: music.eventExternalId,
                  name: await music.name?.translate(),
                  text: await music.text?.translate(),
                  link: music.link,
                  thumbnail: music.thumbnail,
                  order: music.order,
                ),
              ),
            )
          : [],
      prayerRoom: PrayerRoomViewModel(
        externalId: model.prayerRoom?.externalId,
        location: model.prayerRoom?.location,
        text: await model.prayerRoom?.text?.translate(),
        startTime: model.prayerRoom?.startTime,
        finalTime: model.prayerRoom?.finalTime,
      ),
    );
  }
}

class DevotionalsViewModel {
  final String? language;
  final String? link;
  final int? order;
  final bool? isDefault;

  DevotionalsViewModel({
    required this.language,
    required this.link,
    required this.order,
    required this.isDefault,
  });
  DevotionalsEntity toEntity() => DevotionalsEntity(
        language: language,
        link: link,
        order: order,
        isDefault: isDefault,
      );
}

class PrayerRoomViewModel {
  final String? externalId;
  final String? location;
  final String? text;
  final String? startTime;
  final String? finalTime;

  PrayerRoomViewModel({
    required this.externalId,
    required this.location,
    required this.text,
    required this.startTime,
    required this.finalTime,
  });

  String get headerTitleDetails {
    final DateTime? startDateTime = DateTime.tryParse(startTime ?? '');
    final DateTime? finalDateTime = DateTime.tryParse(finalTime ?? '');
    return 'Openning times ${startDateTime?.toFormattedTime} - ${finalDateTime?.toFormattedTime}';
  }
}

class DevotionalTabViewModel {
  final List<SpiritualResultViewModel> devotional;
  final List<DevotionalFilter> filters;
  DevotionalFilter? currentFilter;
  DevotionalsViewModel? devotionalViwed;
  SpiritualResultViewModel? currentItem;

  DevotionalTabViewModel({
    required this.devotional,
    required this.filters,
  }) {
    _setupInitialFilter();
  }

  _setupInitialFilter() {
    currentFilter = filters.isEmpty ? null : filters.first;
    currentItem = devotional.firstWhereOrNull(
        (element) => element.selectedDay == currentFilter?.date);
  }

  void setCurrentFilter({required DevotionalFilter filter}) {
    currentFilter = filter;
    currentItem = devotional.firstWhereOrNull(
        (element) => element.selectedDay == currentFilter?.date);
  }

  void setCurrentLanguageFilter({required DevotionalLanguages filter}) {
    currentItem?.setCurrentLanguageFilter(filter: filter);
  }

  void setCurrentDevotional(DevotionalsViewModel? currentDevotionalViwed) {
    devotionalViwed = currentDevotionalViwed;
  }

  bool get shouldShowEmptyState {
    return devotional.isEmpty || currentItem == null;
  }
}

class DevotionalFilter {
  final String date;

  DevotionalFilter({
    required this.date,
  });

  String get filterDate {
    final DateTime? startDateTime = DateTime.tryParse(date);
    return startDateTime!.filterDate;
  }
}

class DevotionalLanguages {
  final String language;

  DevotionalLanguages({
    required this.language,
  });
}

enum DevotionalDayPeriod {
  morning('morning'),
  afternoon('afternoon'),
  evening('evening');

  const DevotionalDayPeriod(this.value);
  final String value;
}
