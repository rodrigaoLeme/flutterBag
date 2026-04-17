import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/broadcast/broadcast_entity.dart';
import '../../../share/utils/app_color.dart';
import '../../helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/i18n/resources.dart';

class BroadcastsViewModel {
  final List<BroadcastViewModel> broadcasts;
  final List<BroadcastFilter> filters;
  BroadcastFilter? currentFilter;
  BroadcastViewModel? currentVideo;
  BroadcastLanguages? language;
  BroadcastLanguages? languagePlayer;
  BroadcastDayPeriod broadcastDayPeriod;

  BroadcastsViewModel({
    required this.broadcasts,
    required this.filters,
    required this.currentFilter,
    required this.language,
    required this.currentVideo,
    required this.broadcastDayPeriod,
  });

  void setCurrentFilter(
    BroadcastFilter filter,
    BroadcastDayPeriod broadcastDayPeriod,
  ) {
    currentFilter = filter;
    language = filter.broadcastLanguages;
    this.broadcastDayPeriod = broadcastDayPeriod;
  }

  void setCurrentVideo(BroadcastViewModel? video) {
    currentVideo = video;
    language = video?.broadcastLanguages;
    languagePlayer = video?.broadcastLanguages;
  }

  List<BroadcastFilter> filtersByPeriod(BroadcastDayPeriod broadcastDayPeriod) {
    final filtersString = BroadcastsViewModelFactory.makeFilterStringByPeriod(
        broadcasts, broadcastDayPeriod);
    return filtersString
        .map((toElement) => BroadcastFilter(language: toElement ?? ''))
        .toSet()
        .toList();
  }

  bool get showEmptyState {
    final DateTime today = DateTime.now();
    return broadcasts.firstWhereOrNull((element) =>
            element.selectedDay?.toEnDate?.isBefore(today) == true) ==
        null;
  }

  bool hasVideoByPeriodAndCurrentLanguage(
      BroadcastDayPeriod broadcastDayPeriod) {
    return broadCastByType(broadcastDayPeriod).firstWhereOrNull(
            (element) => element.language == language?.contryName) !=
        null;
  }

  List<BroadcastViewModel> broadCastByType(
    BroadcastDayPeriod broadcastDayPeriod,
  ) {
    return BroadcastsViewModelFactory.makePreviousLiveStreams(
      broadcasts,
      currentFilter,
      broadcastDayPeriod,
    );
  }

  void setCurrentLanguage(BroadcastLanguages languageFilter) {
    language = languageFilter;
    languagePlayer = languageFilter;
    currentFilter = BroadcastFilter(language: languageFilter.type);
    final DateTime todayDate = DateTime.now();

    final todayVideo = broadcasts.firstWhereOrNull((element) =>
        element.selectedDay?.toEnDate?.dayToStringEn ==
            todayDate.dayToStringEn &&
        element.language == languageFilter.type &&
        element.period.value == broadcastDayPeriod.value);
    if (todayVideo != null) {
      setCurrentVideo(todayVideo);
    }
  }

  List<BroadcastLanguages?>? get languages {
    final DateTime todayDate = DateTime.now();

    final todayVideos = broadcasts
        .where((element) =>
            element.selectedDay?.toEnDate?.isBefore(todayDate) == true)
        .toList();
    return todayVideos
        .map((element) => BroadcastLanguages.values
            .firstWhereOrNull((item) => item.type == element.language))
        .where((item) => item != null)
        .toSet()
        .toList();
  }
}

class BroadcastsViewModelFactory {
  static Future<BroadcastsViewModel> make(
    BroadcastEntity? model,
    String? language,
  ) async {
    final List<BroadcastViewModel> broadcasts = model?.result != null
        ? await Future.wait<BroadcastViewModel>(
            model!.result!.map(
              (toElement) async => BroadcastViewModel(
                externalId: toElement.externalId,
                title: await toElement.title?.translate(),
                link: toElement.link,
                language: await toElement.language?.translate(),
                dayPeriod: toElement.dayPeriod,
                selectedDay: toElement.selectedDay,
                order: toElement.order,
                period: BroadcastDayPeriod.values.firstWhere(
                  (element) => element.value == toElement.dayPeriod,
                  orElse: () => BroadcastDayPeriod.none,
                ),
              ),
            ),
          )
        : [];

    final filtersString = makeFilterStringByPeriod(
        broadcasts, BroadcastDayPeriod.getCurrentPeriod());
    final filters = filtersString
        .map((toElement) => BroadcastFilter(language: toElement ?? ''))
        .toSet()
        .toList();

    final broadCasViewModel =
        makeBroadcastsViewModel(broadcasts, filters, language);

    String today = DateTime.now().dayToStringEn;

    List<BroadcastViewModel> currentLanguageVideos = broadcasts
        .where((video) => video.selectedDay?.toEnDate?.dayToStringEn == today)
        .toList();
    final containsTodaysCurrentLanguage =
        currentLanguageVideos.firstWhereOrNull((video) =>
            video.language == broadCasViewModel.currentFilter?.language);
    if (containsTodaysCurrentLanguage != null) {
      currentLanguageVideos = currentLanguageVideos
          .where((video) =>
              video.language == broadCasViewModel.currentFilter?.language)
          .toList();
    } else if (currentLanguageVideos.isEmpty) {
      currentLanguageVideos = broadcasts
          .where((video) =>
              video.language == broadCasViewModel.currentFilter?.language)
          .toList();
    } else if (currentLanguageVideos.isNotEmpty) {
      if (currentLanguageVideos[0].broadcastLanguages != null) {
        broadCasViewModel
            .setCurrentLanguage(currentLanguageVideos[0].broadcastLanguages!);
      }
    }

    final newVideo = currentLanguageVideos.firstWhereOrNull((element) =>
            element.selectedDay?.toEnDate?.dayToStringEn == today) ??
        (currentLanguageVideos.isNotEmpty ? currentLanguageVideos.first : null);

    broadCasViewModel.setCurrentVideo(newVideo);
    return broadCasViewModel;
  }

  static List<BroadcastViewModel> makePreviousLiveStreams(
      List<BroadcastViewModel> broadcasts,
      BroadcastFilter? filter,
      BroadcastDayPeriod broadcastDayPeriod) {
    final DateTime today = DateTime.now();
    return broadcasts
        .where(
          (element) =>
              element.language == filter?.language &&
              element.selectedDay?.toEnDate?.isBefore(today) == true &&
              element.period.value == broadcastDayPeriod.value,
        )
        .toList();
  }

  static List<String?> makeFilterStringByPeriod(
    List<BroadcastViewModel> broadcasts,
    BroadcastDayPeriod broadcastDayPeriod,
  ) {
    final DateTime todayDate = DateTime.now();

    final filteredLanguages = broadcasts
        .where((element) =>
            (element.selectedDay?.toEnDate?.isBefore(todayDate) == true &&
                element.period.value == broadcastDayPeriod.value))
        .map((toElement) => toElement.language)
        .toSet()
        .toList();
    return filteredLanguages;
  }

  static BroadcastsViewModel makeBroadcastsViewModel(
      List<BroadcastViewModel> broadcasts,
      List<BroadcastFilter> filters,
      String? language) {
    final broadcastDayPeriod = BroadcastDayPeriod.getCurrentPeriod();
    final String currentLanguage = filters.isNotEmpty
        ? filters.first.broadcastLanguages.broadCastLanguage
        : (language ?? '');
    final broadcastLanguages = BroadcastLanguages.values.firstWhereOrNull(
        (element) => element.broadCastLanguage == currentLanguage);
    return BroadcastsViewModel(
      broadcasts: broadcasts,
      filters: filters,
      currentFilter: filters.firstWhereOrNull((element) =>
              element.language == broadcastLanguages?.contryName) ??
          (filters.isNotEmpty ? filters.first : null),
      language: broadcastLanguages,
      currentVideo: null,
      broadcastDayPeriod: broadcastDayPeriod,
    );
  }
}

class BroadcastViewModel {
  final String? externalId;
  final String? title;
  final String? link;
  final String? language;
  final String? dayPeriod;
  final String? selectedDay;
  final int? order;
  final BroadcastDayPeriod period;

  BroadcastViewModel({
    required this.externalId,
    required this.title,
    required this.link,
    required this.language,
    required this.dayPeriod,
    required this.selectedDay,
    required this.order,
    required this.period,
  });

  String get formatedDate {
    return DateTime.tryParse(selectedDay ?? '')?.weekdayMonth ?? '';
  }

  String get thumbnailUrl {
    final videoId = link?.extractVideoId();
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  String get abbreviatedLanguage {
    return (language?.length ?? 0) >= 3
        ? language?.substring(0, 3).toUpperCase() ?? ''
        : language?.toUpperCase() ?? '';
  }

  BroadcastLanguages? get broadcastLanguages {
    return BroadcastLanguages.values
        .firstWhereOrNull((element) => element.contryName == language);
  }

  String get isLiveLabel {
    final todayDate = DateTime.now();
    final currentPeriod = BroadcastDayPeriod.getCurrentPeriod();
    final isToday =
        selectedDay?.toEnDate?.dayToStringEn == todayDate.dayToStringEn;

    if (!isToday) return R.string.previousLabel;

    if (currentPeriod == period) {
      return R.string.liveLabel;
    }

    final currentIndex = BroadcastDayPeriod.values.indexOf(currentPeriod);
    final videoIndex = BroadcastDayPeriod.values.indexOf(period);

    if (videoIndex < currentIndex) {
      return R.string.previousLabel;
    } else if (videoIndex > currentIndex) {
      return R.string.futureLabel;
    }

    return '';
  }

  Color get isLiveColor {
    final todayDate = DateTime.now();
    final currentPeriod = BroadcastDayPeriod.getCurrentPeriod();
    final isToday =
        selectedDay?.toEnDate?.dayToStringEn == todayDate.dayToStringEn;

    if (!isToday) return AppColors.neutralLowLight;

    if (currentPeriod == period) {
      return AppColors.redMediumLight;
    }

    final currentIndex = BroadcastDayPeriod.values.indexOf(currentPeriod);
    final videoIndex = BroadcastDayPeriod.values.indexOf(period);

    if (videoIndex < currentIndex) {
      return AppColors.neutralLowLight;
    } else if (videoIndex > currentIndex) {
      return AppColors.primaryLight;
    }

    return Colors.transparent;
  }
}

class BroadcastFilter {
  final String language;
  BroadcastFilter({
    required this.language,
  });

  BroadcastLanguages get broadcastLanguages =>
      BroadcastLanguages.values.firstWhere(
        (item) => item.contryName == language,
        orElse: () => BroadcastLanguages.none,
      );
}

enum BroadcastLanguages {
  en('English'),
  pt('Portuguese'),
  es('Spanish'),
  ru('Russian'),
  fr('French'),
  asl('American Sign Language'),
  none('');

  const BroadcastLanguages(this.type);
  final String type;

  String get contryName {
    switch (this) {
      case en:
        return 'English';
      case pt:
        return 'Portuguese';
      case es:
        return 'Spanish';
      case ru:
        return 'Russian';
      case fr:
        return 'French';
      case asl:
        return 'American Sign Language';
      default:
        return 'English';
    }
  }

  String get flag {
    switch (this) {
      case en:
        return 'lib/ui/assets/images/countries/en.png';
      case pt:
        return 'lib/ui/assets/images/countries/br.png';
      case es:
        return 'lib/ui/assets/images/countries/es.png';
      case ru:
        return 'lib/ui/assets/images/countries/ru.png';
      case fr:
        return 'lib/ui/assets/images/countries/fr.png';
      case asl:
        return 'lib/ui/assets/images/countries/asl_.png';
      default:
        return 'lib/ui/assets/images/countries/en.png';
    }
  }

  String get broadCastLanguage {
    switch (this) {
      case en:
        return 'en';
      case pt:
        return 'br';
      case es:
        return 'es';
      case ru:
        return 'ru';
      case fr:
        return 'fr';
      case asl:
        return 'asl';
      default:
        return 'en';
    }
  }
}

enum BroadcastDayPeriod {
  morning('morning'),
  afternoon('afternoon'),
  night('evening'),
  none('');

  const BroadcastDayPeriod(this.value);
  final String value;

  String get tabTitle {
    switch (this) {
      case morning:
        return R.string.morningLabel;
      case afternoon:
        return R.string.afternoonLabel;
      case night:
        return R.string.nightLabel;
      default:
        return '';
    }
  }

  static BroadcastDayPeriod getCurrentPeriod() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    if (hour < 13 || (hour == 13 && minute == 0)) {
      return BroadcastDayPeriod.morning;
    }

    if ((hour == 13 && minute > 0) ||
        (hour > 13 && hour < 17) ||
        (hour == 17 && minute <= 30)) {
      return BroadcastDayPeriod.afternoon;
    }

    if ((hour == 17 && minute > 30) || (hour >= 18 && hour <= 23)) {
      return BroadcastDayPeriod.night;
    }

    return BroadcastDayPeriod.none;
  }
}
