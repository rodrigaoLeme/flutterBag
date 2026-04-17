import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/agenda/remote_agenda_model.dart';
import '../../../data/models/exhibition/exhibition.dart';
import '../../../data/models/food/remote_food_model.dart';
import '../../../data/models/map/remote_map_model.dart';
import '../../../data/models/news/remote_news_model.dart';
import '../../../data/models/notification/remote_notification_model.dart';
import '../../../data/models/section/section_model.dart';
import '../../../data/models/spiritual/remote_spiritual_model.dart';
import '../../../data/models/sponsor/remote_sponsor_model.dart';
import '../../../data/models/voting/remote_voting_model.dart';
import '../../../domain/entities/exhibition/exhibition_entity.dart';
import '../../../domain/entities/food/food_entity.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/entities/push_notification/notification_type_entity.dart';
import '../../../domain/usecases/agenda/load_current_agenda.dart';
import '../../../domain/usecases/dashboard/load_schedule.dart';
import '../../../domain/usecases/dashboard/load_section.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/exhibition/load_current_exhibitor.dart';
import '../../../domain/usecases/exhibition/load_exhibition.dart';
import '../../../domain/usecases/exhibition/save_current_exhibition.dart';
import '../../../domain/usecases/food/load_current_external_food.dart';
import '../../../domain/usecases/food/load_external_food.dart';
import '../../../domain/usecases/food/save_current_external_food.dart';
import '../../../domain/usecases/map/load_map.dart';
import '../../../domain/usecases/push_notification/load_current_notification.dart';
import '../../../domain/usecases/push_notification/load_current_screen_type.dart';
import '../../../domain/usecases/push_notification/load_notification.dart';
import '../../../domain/usecases/push_notification/load_notification_once.dart';
import '../../../domain/usecases/spiritual/load_spiritual.dart';
import '../../../domain/usecases/sponsor/load_sponsor.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/dashboard/section_view_model.dart';
import '../../../ui/modules/dashboard/sponsor_view_model.dart';
import '../../../ui/modules/food/food_view_model.dart';
import '../../../ui/modules/maps/maps_view_model.dart';
import '../../../ui/modules/modules.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../mixins/mixins.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../navigation_bar/tab_bar_itens.dart';

class StreamDashboardPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements DashboardPresenter {
  final LoadNews loadNews;
  final LoadNotification loadNotification;
  final LoadSchedule loadSchedule;
  final LoadVoting loadVoting;
  final LoadSection loadSection;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadAgenda loadAgenda;
  final LoadNews loadNewsUsecase;
  final LoadExternalFood loadExternalFood;
  final LoadCurrentExternalFood loadCurrentExternalFood;
  final SaveCurrentExternalFood localSaveCurrentFood;
  final LoadCurrentScreenType loadCurrentScreenType;
  final LoadExhibition loadExhibition;
  final LoadSpiritual loadSpirituals;
  final LoadSponsor loadSponsor;
  final SaveCurrentExhibition localSaveCurrentExhibitor;
  final LoadCurrentExhibitor loadCurrentExhibitor;
  final LoadCurrentAgenda loadCurrentAgenda;
  final LoadMap loadMap;
  final LoadNotificationOnce loadNotificationOnce;
  final LoadCurrentNotification loadCurrentNotification;

  StreamDashboardPresenter({
    required this.loadNews,
    required this.loadNotification,
    required this.loadSchedule,
    required this.loadVoting,
    required this.loadSection,
    required this.loadCurrentEvent,
    required this.loadAgenda,
    required this.loadNewsUsecase,
    required this.loadExternalFood,
    required this.loadCurrentExternalFood,
    required this.localSaveCurrentFood,
    required this.loadCurrentScreenType,
    required this.loadExhibition,
    required this.loadSpirituals,
    required this.loadSponsor,
    required this.localSaveCurrentExhibitor,
    required this.loadCurrentExhibitor,
    required this.loadCurrentAgenda,
    required this.loadMap,
    required this.loadNotificationOnce,
    required this.loadCurrentNotification,
  });

  final StreamController<SectionsViewModel?> _viewModel =
      StreamController<SectionsViewModel?>.broadcast();
  @override
  Stream<SectionsViewModel?> get viewModel => _viewModel.stream;

  final StreamController<ExhibitionsViewModel?> _exhibitionViewModel =
      StreamController<ExhibitionsViewModel?>.broadcast();
  @override
  Stream<ExhibitionsViewModel?> get exhibitionViewModel =>
      _exhibitionViewModel.stream;

  final ValueNotifier<VotingsViewModel?> _votingViewModel =
      ValueNotifier<VotingsViewModel?>(null);
  @override
  ValueNotifier<VotingsViewModel?> get votingViewModel => _votingViewModel;

  final ValueNotifier<int?> _notificationReadCount = ValueNotifier<int?>(null);
  @override
  ValueNotifier<int?> get notificationReadCount => _notificationReadCount;

  final StreamController<AgendaViewModel?> _agendaViewModel =
      StreamController<AgendaViewModel?>.broadcast();
  @override
  Stream<AgendaViewModel?> get agendaViewModel => _agendaViewModel.stream;

  final StreamController<NewsListViewModel?> _newsViewModel =
      StreamController<NewsListViewModel?>.broadcast();
  @override
  Stream<NewsListViewModel?> get newsViewModel => _newsViewModel.stream;

  final StreamController<FoodViewModel?> _foodViewModel =
      StreamController<FoodViewModel?>.broadcast();
  @override
  Stream<FoodViewModel?> get foodViewModel => _foodViewModel.stream;

  final StreamController<SpiritualViewModel?> _spiritualViewModel =
      StreamController<SpiritualViewModel?>.broadcast();
  @override
  Stream<SpiritualViewModel?> get spiritualViewModel =>
      _spiritualViewModel.stream;

  final StreamController<SponsorsViewModel?> _sponsorsViewModel =
      StreamController<SponsorsViewModel?>.broadcast();
  @override
  Stream<SponsorsViewModel?> get sponsorsViewModel => _sponsorsViewModel.stream;

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

  Future<void> loadMaps() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      loadMap
          .load(
        params: LoadMapParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteMapModel.fromDocument(document);
            final maps = await MapsViewModelFactory.make(model);
            final paramController = Modular.get<ParamController>();
            paramController.setViewModel(maps);
          } catch (e) {
            print(e.toString());
          }
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Future<void> loadExhibitions() async {
    try {
      final event = await loadCurrentEvent.load();
      final favorites = await loadExhibitorFavorites();

      loadExhibition
          .load(params: LoadExhibitionParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteExhibitionModel.fromDocument(document);
            final exhibitionViewModel = await ExhibitionViewModelFactory.make(
              model: model,
              favorites: favorites,
            );
            _exhibitionViewModel.add(exhibitionViewModel);
          } catch (e) {
            _exhibitionViewModel.addError(e);
          }
        },
        onError: (error) {
          _exhibitionViewModel.addError(error);
        },
      );
    } catch (error) {
      _exhibitionViewModel.addError(error);
    }
  }

  @override
  Future<void> loadSponsors() async {
    try {
      final event = await loadCurrentEvent.load();
      loadSponsor
          .load(params: LoadSponsorParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteSponsorModel.fromDocument(document);
            final sponsorsViewModel =
                await SponsorsViewModelFactory.make(model);
            _sponsorsViewModel.add(sponsorsViewModel);
          } catch (e) {
            _sponsorsViewModel.addError(e);
          }
        },
        onError: (error) {
          _sponsorsViewModel.addError(error);
        },
      );
    } catch (error) {
      _sponsorsViewModel.addError(error);
    }
  }

  @override
  Future<void> loadSections() async {
    try {
      final event = await loadCurrentEvent.load();
      loadMaps();
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
  Future<void> fetchVotings() async {
    try {
      final event = await loadCurrentEvent.load();
      loadVoting
          .load(params: LoadVotingParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = VotingResultModel.fromDocument(document);
            final votingViewModel =
                await VotingsViewModelFactory.make(model: model);
            _votingViewModel.value = votingViewModel;
          } catch (e) {
            _votingViewModel.value = null;
          }
        },
        onError: (error) {
          _votingViewModel.value = null;
        },
      );
    } catch (error) {
      _votingViewModel.value = null;
    }
  }

  @override
  Future<void> fetchAgenda() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final favorites = await loadCurrentAgenda.load(
        params: LoadCurrentAgendaParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
      loadAgenda
          .load(
              params: LoadScheduleParams(
                  eventSchedule: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteAgendaModel.fromDocument(document);
            final scheduleViewModel = await ScheduleViewModelFactory.make(
              entity: model.toEntity(),
              favorites: favorites,
            );
            _agendaViewModel.add(scheduleViewModel);
          } catch (e) {
            _agendaViewModel.add(null);
          }
        },
        onError: (error) {
          _agendaViewModel.add(null);
        },
      );
    } catch (error) {
      _agendaViewModel.add(null);
    }
  }

  @override
  Future<void> fetchFood() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final favorites = await loadCurrentExternalFood.load(
        params: LoadCurrentExternalFoodParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
      loadExternalFood
          .load(
              params: LoadExternalFoodParams(
        eventId: currentEvent?.externalId ?? '',
      ))
          ?.listen(
        (document) async {
          try {
            final model = RemoteResultFoodModel.fromDocument(document);
            final foodViewModel = await ExternalFoodListViewModelFactory.make(
                model: model, favorites: favorites);
            _foodViewModel.add(foodViewModel);
          } catch (e) {
            _foodViewModel.addError(e);
          }
        },
        onError: (error) {
          _foodViewModel.addError(error);
        },
      );
    } catch (error) {
      _foodViewModel.addError(error);
    }
  }

  @override
  Future<void> fetchNews() async {
    try {
      final currentEvent = await loadCurrentEvent.load();

      loadNews
          .load(params: LoadNewsParams(eventId: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteListNewsModel.fromDocument(document);

            final viewModel = await NewsViewModelFactory.make(
              RemoteListNewsModel(
                newsList: model.newsList,
              ),
            );

            _newsViewModel.add(viewModel);
          } catch (e) {
            _newsViewModel.addError(e);
          }
        },
        onError: (error) {
          _newsViewModel.addError(error);
        },
      );
    } catch (error) {
      _newsViewModel.addError(error);
    }
  }

  @override
  Future<void> saveFavorites({
    required ExternalFoodViewModel food,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final eventEntity = food.toEntity();
      final FoodResultEntity favoriteFood =
          await loadFavorites() ?? FoodResultEntity(foodExternal: []);
      if (favoriteFood.foodExternal?.firstWhereOrNull(
              (element) => element.externalId == eventEntity.externalId) !=
          null) {
        favoriteFood.foodExternal?.removeWhere(
            (element) => element.externalId == eventEntity.externalId);
      } else {
        favoriteFood.foodExternal?.add(eventEntity);
      }
      final eventMap = favoriteFood.toJson();
      final json = jsonEncode(eventMap);
      await localSaveCurrentFood.save(
          params: SaveCurrentExternalFoodParams(
              eventId: currentEvent?.externalId ?? '', data: json));
      await fetchFood();
    } catch (error) {
      return;
    }
  }

  Future<FoodResultEntity?> loadFavorites() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      return await loadCurrentExternalFood.load(
        params: LoadCurrentExternalFoodParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> loadSpiritual() async {
    try {
      final event = await loadCurrentEvent.load();
      loadSpirituals
          .load(params: LoadSpiritualParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteSpiritualModel.fromDocument(document);
            final spiritualViewModel =
                await SpiritualViewModelFactory.make(model);
            _spiritualViewModel.add(spiritualViewModel);
          } catch (e) {
            _spiritualViewModel.addError(e);
          }
        },
        onError: (error) {
          _spiritualViewModel.addError(error);
        },
      );
    } catch (error) {
      _spiritualViewModel.addError(error);
    }
  }

  @override
  Future<ExhibitionViewModel> savedFavorites({
    required ExhibitionViewModel exhibitor,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final exhibitorEntity = exhibitor.toEntity();
      final ExhibitionEntity favoriteExhibitor =
          await loadExhibitorFavorites() ?? ExhibitionEntity(exhibitor: []);
      if (favoriteExhibitor.exhibitor?.firstWhereOrNull(
              (element) => element.externalId == exhibitorEntity.externalId) !=
          null) {
        favoriteExhibitor.exhibitor?.removeWhere(
            (element) => element.externalId == exhibitorEntity.externalId);
      } else {
        favoriteExhibitor.exhibitor?.add(exhibitorEntity);
      }
      final eventMap = favoriteExhibitor.toJson();
      final json = jsonEncode(eventMap);
      await localSaveCurrentExhibitor.save(
          params: SaveCurrentExhibitionParams(
              eventId: currentEvent?.externalId ?? '', data: json));
      await loadExhibitions();
      exhibitor.setIsFavorite();
      return exhibitor;
    } catch (error) {
      return exhibitor;
    }
  }

  Future<ExhibitionEntity?> loadExhibitorFavorites() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      return await loadCurrentExhibitor.load(
        params: LoadCurrentExhibitorParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> loadNotificationReadCount() async {
    try {
      final currentEvent = await loadCurrentEvent.load();

      loadNotification
          .load(
              params: LoadNotificationParams(
        eventId: currentEvent?.externalId ?? '',
      ))
          ?.listen(
        (document) async {
          try {
            final notificationsRead = await loadNotificationRead();
            final model = RemoteNotificationModel.fromDocument(document);
            final remoteNotifications = model.notification ?? [];

            final remoteIds =
                remoteNotifications.map((n) => n.externalId).toSet();

            final validReadIds = (notificationsRead ?? [])
                .where((readId) => remoteIds.contains(readId.externalId))
                .toList();

            final count = remoteNotifications.length - validReadIds.length;

            notificationReadCount.value = count <= 0 ? null : count;
          } catch (e) {
            notificationReadCount.value = null;
          }
        },
        onError: (error) {
          notificationReadCount.value = null;
        },
      );
    } catch (error) {
      notificationReadCount.value = null;
    }
  }

  Future<List<NotificationResultEntity>?> loadNotificationRead() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final notifications = await loadCurrentNotification.load(
        params: LoadCurrentNotificationParams(
            eventId: currentEvent?.externalId ?? ''),
      );
      return notifications?.notification;
    } catch (e) {
      return [];
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    _votingViewModel.dispose();
  }

  @override
  void goToEventDetails(detailsViewModel) {
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
      route: Routes.agenda,
      clear: false,
      arguments: SchedulePageNavigationData(
        currentIndex: 1,
        shouldPresentArrowBack: false,
      ),
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
  void goToFood(SectionType type) {
    Modular.to.pushNamed(Routes.food, arguments: type);
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
  void goToNotification() {
    navigateTo = NavigationData(
      route: Routes.notification,
      clear: false,
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
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getVoting() {
    try {
      return loadVoting.load(params: LoadVotingParams(eventId: '4'));
    } catch (error) {
      return null;
    }
  }

  @override
  void goToBusiness() {
    navigateTo = NavigationData(
      route: Routes.business,
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
  void goToDocuments() {
    navigateTo = NavigationData(route: Routes.documents, clear: false);
  }

  @override
  void goToTranslationChannel() {
    navigateTo = NavigationData(route: Routes.translationChannel, clear: false);
  }

  @override
  void showLoadingFlow({required bool loading}) {
    isLoading = LoadingData(isLoading: loading);
  }
}
