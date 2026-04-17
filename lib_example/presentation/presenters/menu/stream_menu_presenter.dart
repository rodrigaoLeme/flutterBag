import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/section/section_model.dart';
import '../../../data/models/spiritual/remote_spiritual_model.dart';
import '../../../domain/entities/push_notification/notification_type_entity.dart';
import '../../../domain/usecases/dashboard/load_section.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/menu/load_menu.dart';
import '../../../domain/usecases/push_notification/load_current_screen_type.dart';
import '../../../domain/usecases/spiritual/load_spiritual.dart';
import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../domain/usecases/translation/save_current_translation.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/extensions/date_formater_extension.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/dashboard/section_view_model.dart';
import '../../../ui/modules/menu/menu_presenter.dart';
import '../../../ui/modules/navigation/navigation_bar_presenter.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../../ui/modules/translation/translation_view_model.dart';
import '../../mixins/mixins.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../navigation_bar/tab_bar_itens.dart';

class StreamMenuPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements MenuPresenter {
  final LoadMenu loadMenu;
  final LoadSection loadSection;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentScreenType loadCurrentScreenType;
  final LoadSpiritual loadSpiritual;
  SpiritualViewModel? _spiritualViewModel;

  final SaveCurrentTranslation saveCurrentTranslation;
  final LoadCurrentTranslation loadCurrentTranslation;
  bool shouldReloadView = false;
  final ValueNotifier<TranslationViewModel?> _translationViewModel =
      ValueNotifier<TranslationViewModel?>(null);
  @override
  ValueNotifier<TranslationViewModel?> get translationViewModel =>
      _translationViewModel;

  StreamMenuPresenter({
    required this.saveCurrentTranslation,
    required this.loadCurrentTranslation,
    required this.loadMenu,
    required this.loadSection,
    required this.loadCurrentEvent,
    required this.loadCurrentScreenType,
    required this.loadSpiritual,
  });

  final StreamController<SectionsViewModel?> _viewModel =
      StreamController<SectionsViewModel?>.broadcast();
  @override
  Stream<SectionsViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      final message = await loadCurrentScreenType.load();
      if (message?.data['topic'] != null) {
        final topic = message?.data['topic'];
        if (topic == NotificationTypeEntity.fullScreen.value) {
          PushFullscreenManager().isShowing = message!;
        }
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> loadData() async {
    try {
      final lenguageString = await loadCurrentTranslation.load();
      final lenguage = Languages.values
          .firstWhereOrNull((element) => element.type == lenguageString);
      final isTranslateEnable = FeatureFlags().isTranslateEnable();
      _translationViewModel.value = TranslationViewModel(
          currentLanguage: lenguage, isTranslateEnable: isTranslateEnable);
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    _translationViewModel.dispose();
  }

  @override
  Future<void> loadSections() async {
    try {
      final event = await loadCurrentEvent.load();
      loadSection
          .load(params: LoadSectionParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = SectionResultModel.fromDocument(document);
            final votingViewModel = await SectionsViewModelFactory.make(model);
            _viewModel.add(votingViewModel);
          } catch (e) {
            _viewModel.addError(e);
          }
        },
        onError: (error) {
          _viewModel.addError(error);
        },
      );
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  Future<void> loadDataSpiritual() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadSpiritual
          .load(
        params: LoadSpiritualParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteSpiritualModel.fromDocument(document);
            _spiritualViewModel = await SpiritualViewModelFactory.make(model);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {},
      );
    } catch (error) {}
  }

  @override
  void goToNotification() {
    navigateTo = NavigationData(route: Routes.notification, clear: false);
  }

  @override
  void goToEventDetails() {
    navigateTo = NavigationData(
      route: Routes.eventDetails,
      clear: false,
    );
  }

  @override
  void goToAgenda() {
    navigateTo = NavigationData(
      route: Routes.agenda,
      clear: false,
    );
  }

  @override
  void goToMyAgenda() {
    navigateTo = NavigationData(
      route: Routes.myAgenda,
      clear: false,
    );
  }

  @override
  void goToNews() {
    navigateTo = NavigationData(
      route: Routes.news,
      clear: false,
    );
  }

  @override
  void goToStLouis() {
    navigateTo = NavigationData(
      route: Routes.stLouis,
      clear: false,
    );
  }

  @override
  void goToExhibition() {
    navigateTo = NavigationData(
      route: Routes.exhibition,
      clear: false,
    );
  }

  @override
  void goToSupport() {
    navigateTo = NavigationData(
      route: Routes.support,
      clear: false,
    );
  }

  @override
  void goToProfile() {
    navigateTo = NavigationData(
      route: Routes.profile,
      clear: false,
    );
  }

  @override
  void goToFood() {
    navigateTo = NavigationData(
      route: Routes.food,
      clear: false,
      arguments: SectionType.restaurantsExternal,
    );
  }

  @override
  void goToVoting() {
    navigateTo = NavigationData(
      route: Routes.voting,
      clear: false,
    );
  }

  @override
  void goToMap() {
    navigateTo = NavigationData(
      route: Routes.map,
      clear: false,
    );
  }

  @override
  void chooseEvent() {
    navigateTo = NavigationData(
      route: Routes.chooseEvent,
      clear: true,
    );
  }

  @override
  void goToEmergency() {
    navigateTo = NavigationData(
      route: Routes.emergency,
      clear: false,
    );
  }

  @override
  void goToSpiritual() {
    navigateTo = NavigationData(
      route: Routes.spiritual,
      clear: false,
    );
  }

  @override
  void goToTranslation() {
    navigateTo = NavigationData(
      route: Routes.translation,
      clear: false,
    );
  }

  @override
  void goToBrochures() {
    navigateTo = NavigationData(
      route: Routes.brochures,
      clear: false,
    );
  }

  @override
  void goToDocuments() {
    navigateTo = NavigationData(
      route: Routes.documents,
      clear: false,
    );
  }

  @override
  void goToBroadcast() {
    navigateTo = NavigationData(
      route: Routes.broadcast,
      clear: false,
    );
  }

  @override
  void goToPrayerRoom() {
    Modular.to.pushNamed(
      Routes.prayerRoom,
      arguments: _spiritualViewModel?.prayerRoom,
    );
  }

  @override
  void goToMusic() {
    Modular.to.pushNamed(
      Routes.music,
      arguments: _spiritualViewModel,
    );
  }

  @override
  void goToDevotional() {
    Modular.to.pushNamed(
      Routes.devotional,
      arguments: _spiritualViewModel,
    );
  }

  @override
  void goToTransportation() {
    navigateTo = NavigationData(
      route: Routes.transport,
      clear: false,
    );
  }

  @override
  void goToSocialMedia() {
    navigateTo = NavigationData(
      route: Routes.socialMedia,
      clear: false,
    );
  }

  @override
  void goToTranslationChannel() {
    navigateTo = NavigationData(
      route: Routes.translationChannel,
      clear: false,
    );
  }

  @override
  Future<void> goToHome() async {
    if (shouldReloadView) {
      await Future.delayed(const Duration(milliseconds: 300));
      final presenter = Modular.get<NavigationBarPresenter>();
      presenter.setCurrentTab(tab: TabBarItens.home);
      navigateTo = NavigationData(route: Routes.splash, clear: true);
    }
  }

  @override
  Future<void> chooseLenguage({required Languages language}) async {
    try {
      final currentType = _translationViewModel.value?.currentLanguage?.type;
      if (currentType != language.type) {
        await saveCurrentTranslation.save(language.type);
        await loadData();
        await setLocale(language.locale);
        shouldReloadView = true;
      }
    } catch (e) {
      return;
    }
  }

  @override
  void routeToBy(SectionViewModel section) {
    switch (section.sectionTypeFromMenu) {
      case SectionType.schedule:
        final presenter = Modular.get<NavigationBarPresenter>();
        presenter.setCurrentTab(tab: TabBarItens.schedule);
      case SectionType.exhibitions:
        final presenter = Modular.get<NavigationBarPresenter>();
        presenter.setCurrentTab(tab: TabBarItens.exhibitions);
      case SectionType.restaurants:
        goToFood();
      case SectionType.newlyElected:
        goToVoting();
      case SectionType.worship:
        goToDevotional();
      case SectionType.music:
        goToMusic();
      case SectionType.prayerRoom:
        goToPrayerRoom();
      case SectionType.news:
        goToNews();
      case SectionType.resources:
        goToBrochures();
      case SectionType.spiritual:
        goToSpiritual();
      case SectionType.documents:
        goToDocuments();
      case SectionType.liveStream:
        goToBroadcast();
      case SectionType.transport:
        goToTransportation();
      case SectionType.accessibility:
        goToAccessibility();
      case SectionType.socialMedia:
        goToSocialMedia();
      case SectionType.translationChannel:
        goToTranslationChannel();
      default:
        break;
    }
  }

  @override
  void goToAccessibility() {
    navigateTo = NavigationData(
      route: Routes.accessibility,
      clear: false,
    );
  }
}
