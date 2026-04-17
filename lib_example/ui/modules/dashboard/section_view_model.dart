import 'dart:ui';

import 'package:collection/collection.dart';

import '../../../data/models/section/section_model.dart';
import '../../../share/utils/app_color.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/helpers.dart';

class SectionsViewModel {
  final List<SectionViewModel>? sections;

  SectionsViewModel({
    required this.sections,
  });

  List<SectionType>? get sectionTypeList {
    return sections
        ?.map((section) => section.sectionType)
        .whereType<SectionType>()
        .toSet()
        .toList();
  }

  List<MenuGroup> get menuGroup {
    return makeGroup();
  }

  List<MenuGroup> makeGroup() {
    final foodGroup = [
      SectionType.restaurants,
      SectionType.translationChannel,
      SectionType.transport,
      SectionType.accessibility,
    ];

    final businessGroup = [
      SectionType.newlyElected,
      SectionType.documents,
      SectionType.resources,
    ];

    final mediaGroup = [
      SectionType.news,
      SectionType.liveStream,
      SectionType.socialMedia,
    ];

    List<SectionViewModel>? filterGroup(MenuGroupType menuType) {
      if (menuType == MenuGroupType.spiritualGroup) {
        return [
          SectionViewModel(
            description: R.string.musicLabel,
            name: R.string.musicLabel,
            slug: 'MUSIC',
          ),
          SectionViewModel(
            description: R.string.prayerRoomLabel,
            name: R.string.prayerRoomLabel,
            slug: 'PRAYER_ROOM',
          ),
          SectionViewModel(
            description: R.string.worship,
            name: R.string.worship,
            slug: 'WORSHIP',
          ),
        ];
      }
      if (menuType == MenuGroupType.businessGroup) {
        return sections
            ?.where((section) =>
                businessGroup.contains(section.sectionTypeFromSideMenu))
            .toList();
      }
      if (menuType == MenuGroupType.mediaGroup) {
        return sections
            ?.where((section) =>
                mediaGroup.contains(section.sectionTypeFromSideMenu))
            .toList();
      }
      if (menuType == MenuGroupType.foodGroup) {
        return sections
            ?.where((section) =>
                foodGroup.contains(section.sectionTypeFromSideMenu))
            .toList();
      }
      return [];
    }

    List<MenuGroup> groups = [];
    final bottomItems = sections
        ?.where((s) =>
            s.slug == SectionType.emergency.value ||
            s.slug == SectionType.faq.value)
        .toList();

    if (bottomItems != null && bottomItems.isNotEmpty) {
      groups.add(
        MenuGroup(
          title: '',
          group: bottomItems,
          type: MenuGroupType.bottomMenuGroup,
        ),
      );
    }
    if (sections?.firstWhereOrNull(
            (element) => element.slug == SectionType.spiritual.value) !=
        null) {
      groups.add(
        MenuGroup(
          title: R.string.spiritualContent,
          group: filterGroup(MenuGroupType.spiritualGroup),
          type: MenuGroupType.spiritualGroup,
        ),
      );
    }
    if (sections?.firstWhereOrNull(
                (element) => element.slug == SectionType.documents.value) !=
            null ||
        sections?.firstWhereOrNull(
                (element) => element.slug == SectionType.newlyElected.value) !=
            null ||
        sections?.firstWhereOrNull(
                (element) => element.slug == SectionType.resources.value) !=
            null) {
      groups.add(
        MenuGroup(
          title: R.string.businessLabel,
          group: filterGroup(MenuGroupType.businessGroup),
          type: MenuGroupType.businessGroup,
        ),
      );
    }
    groups.add(
      MenuGroup(
        title: R.string.mediaLabel,
        group: filterGroup(MenuGroupType.mediaGroup),
        type: MenuGroupType.mediaGroup,
      ),
    );
    groups.add(
      MenuGroup(
        title: R.string.infoLabel,
        group: filterGroup(MenuGroupType.foodGroup),
        type: MenuGroupType.foodGroup,
      ),
    );

    return groups;
  }
}

class SectionViewModel {
  final String? slug;
  final String? name;
  final String? description;

  SectionViewModel({
    required this.slug,
    required this.name,
    required this.description,
  });

  SectionType? get sectionType {
    if (slug == SectionType.emergency.value || slug == SectionType.faq.value) {
      return SectionType.bottomMenu;
    }

    if (slug == SectionType.liveStream.value ||
        slug == SectionType.documents.value) {
      return SectionType.actions;
    }

    return SectionType.values.firstWhere(
      (element) => element.value == slug,
      orElse: () => SectionType.none,
    );
  }

  SectionType? get sectionTypeFromSideMenu {
    if (slug == SectionType.emergency.value || slug == SectionType.faq.value) {
      return SectionType.bottomMenu;
    }

    return SectionType.values.firstWhere(
      (element) => element.value == slug,
      orElse: () => SectionType.none,
    );
  }

  SectionType? get sectionTypeFromMenu {
    return SectionType.values.firstWhere(
      (element) => element.value == slug,
      orElse: () => SectionType.none,
    );
  }
}

class SectionsViewModelFactory {
  static Future<SectionsViewModel> make(SectionResultModel model) async {
    return SectionsViewModel(
      sections: model.sections != null
          ? await Future.wait(
              model.sections!.map(
                (element) async => SectionViewModel(
                  slug: element.slug,
                  name: await element.name?.translateMenu(),
                  description: element.description,
                ),
              ),
            )
          : [],
    );
  }
}

enum SectionType {
  schedule('SCHEDULE'),
  notification('NOTIFICATION'),
  emergency('EMERGENCY'),
  turism('TOURISM'),
  spiritual('SPIRITUAL'),
  news('NEWS'),
  exhibitions('EXHIBITIONS'),
  restaurants('RESTAURANT'),
  newlyElected('VOTING_RESULT'),
  actions('ACTIONS'),
  card('CARDS'),
  faq('FAQ'),
  myAgenda('MY_AGENDA'),
  liveStream('LIVE_BROADCAST'),
  sponsor('SPONSOR'),
  bottomMenu('BOTTOM_MENU'),
  documents('DOCUMENTS'),
  resources('BROCHURES'),
  restaurantsExternal('RESTAURANTS_EXTERNAL'),
  restaurantsInternal('RESTAURANTS_INTERNAL'),
  worship('WORSHIP'),
  music('MUSIC'),
  prayerRoom('PRAYER_ROOM'),
  business('BUSINESS'),
  translationChannel('TRANSLATION_CHANNEL'),
  transport('TRANSPORT'),
  accessibility('ACCESSIBILITY'),
  socialMedia('SOCIAL_MEDIA'),
  none('');

  const SectionType(this.value);
  final String value;

  String get icon {
    return 'lib/ui/assets/images/icon/$value.svg';
  }

  Color get colorForSection {
    switch (this) {
      case SectionType.business:
        return AppColors.primaryLight;
      case SectionType.documents:
        return AppColors.sunFlower;
      case SectionType.liveStream:
        return AppColors.liveColor;
      default:
        return AppColors.onSecundaryContainer;
    }
  }

  String getImageForSection({required bool isFolder}) {
    switch (this) {
      case SectionType.business:
        return 'lib/ui/assets/images/icon/check-to-slot-solid.svg';
      case SectionType.documents:
        return isFolder
            ? 'lib/ui/assets/images/icon/folder-solid.svg'
            : 'lib/ui/assets/images/icon/files-light.svg';
      case SectionType.liveStream:
        return 'lib/ui/assets/images/icon/video-solid.svg';
      case SectionType.schedule:
        return 'lib/ui/assets/images/icon/calendar-regular.svg';
      case SectionType.newlyElected:
        return 'lib/ui/assets/images/icon/ballot-light.svg';
      case SectionType.resources:
        return 'lib/ui/assets/images/icon/book-open-light.svg';
      case SectionType.worship:
        return isFolder
            ? 'lib/ui/assets/images/icon/book-bible-light.svg'
            : 'lib/ui/assets/images/icon/book-bible-regular.svg';
      case SectionType.music:
        return isFolder
            ? 'lib/ui/assets/images/icon/music-light.svg'
            : 'lib/ui/assets/images/icon/music-regular.svg';
      case SectionType.prayerRoom:
        return isFolder
            ? 'lib/ui/assets/images/icon/person-praying-light.svg'
            : 'lib/ui/assets/images/icon/person-praying-regular.svg';
      case SectionType.restaurantsInternal:
        return 'lib/ui/assets/images/dining_hall.png';
      case SectionType.restaurantsExternal:
        return 'lib/ui/assets/images/local_restaurants.png';
      default:
        return '';
    }
  }

  String getTitleForSection({required bool isFolder}) {
    switch (this) {
      case SectionType.business:
        return R.string.businessLabel;
      case SectionType.documents:
        return isFolder ? R.string.docsLabel : R.string.documentsLabel;
      case SectionType.liveStream:
        return R.string.liveBroadcastLabel;
      case SectionType.schedule:
        return R.string.mySchedule;
      case SectionType.newlyElected:
        return R.string.votingInformationLabel;
      case SectionType.resources:
        return R.string.brochuresLabel;
      case SectionType.worship:
        return R.string.devotionalLabel;
      case SectionType.music:
        return R.string.musicLabel;
      case SectionType.prayerRoom:
        return R.string.prayerRoomLabel;
      case SectionType.restaurantsInternal:
        return R.string.diningHall;
      case SectionType.restaurantsExternal:
        return R.string.localRestaurant;
      default:
        return '';
    }
  }
}

class MenuGroup {
  final String title;
  final List<SectionViewModel>? group;
  final MenuGroupType type;

  MenuGroup({
    required this.title,
    required this.group,
    required this.type,
  });
}

enum MenuGroupType {
  bottomMenuGroup,
  mediaGroup,
  foodGroup,
  businessGroup,
  votesGroup,
  spiritualGroup,
}
