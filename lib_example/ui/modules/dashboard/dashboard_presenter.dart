import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import '../agenda/agenda_view_model.dart';
import '../exhibition/exhibition.dart';
import '../food/food_view_model.dart';
import '../news/news_view_model.dart';
import '../spiritual/spiritual_view_model.dart';
import '../voting/voting_view_model.dart';
import 'section_view_model.dart';
import 'sponsor_view_model.dart';

abstract class DashboardPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SectionsViewModel?> get viewModel;
  ValueNotifier<VotingsViewModel?> get votingViewModel;
  Stream<AgendaViewModel?> get agendaViewModel;
  Stream<NewsListViewModel?> get newsViewModel;
  Stream<FoodViewModel?> get foodViewModel;
  Stream<ExhibitionsViewModel?> get exhibitionViewModel;
  Stream<SpiritualViewModel?> get spiritualViewModel;
  Stream<SponsorsViewModel?> get sponsorsViewModel;
  Stream<LoadingData?> get isLoadingStream;
  ValueNotifier<int?> get notificationReadCount;

  Future<void> loadSections();
  Future<void> fetchVotings();
  Future<void> fetchAgenda();
  void dispose();
  Future<void> fetchNews();
  Future<void> fetchFood();
  Future<void> saveFavorites({
    required ExternalFoodViewModel food,
  });
  Future<void> loadExhibitions();
  Future<void> loadSpiritual();
  Future<void> loadSponsors();

  void goToEventDetails(detailsViewModel);
  void goToAgenda();
  void goToMyAgenda();
  void goToNews();
  void goToStLouis();
  void goToExhibition();
  void goToSupport();
  void goToProfile();
  void goToFood(SectionType type);
  void goToVoting();
  void goToMap();
  void chooseEvent();
  void goToNotification();
  void goToEmergency();
  void goToSpiritual();
  void goToTranslation();
  void goToBusiness();
  void goToBroadcast();
  void goToDocuments();
  void goToTranslationChannel();
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getVoting();
  Future<void> convinienceInit();
  Future<ExhibitionViewModel> savedFavorites({
    required ExhibitionViewModel exhibitor,
  });
  void showLoadingFlow({required bool loading});
  Future<void> loadNotificationReadCount();
}
