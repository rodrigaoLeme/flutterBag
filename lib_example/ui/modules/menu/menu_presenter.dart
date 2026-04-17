import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import '../dashboard/section_view_model.dart';
import '../translation/translation_view_model.dart';

abstract class MenuPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SectionsViewModel?> get viewModel;

  Future<void> loadSections();
  ValueNotifier<TranslationViewModel?> get translationViewModel;

  Future<void> loadData();
  Future<void> convinienceInit();
  void dispose();
  void goToNotification();
  void goToEventDetails();
  void goToAgenda();
  void goToMyAgenda();
  void goToNews();
  void goToStLouis();
  void goToExhibition();
  void goToSupport();
  void goToProfile();
  void goToFood();
  void goToVoting();
  void goToMap();
  void chooseEvent();
  void goToEmergency();
  void goToSpiritual();
  void goToTranslation();
  void goToHome();
  void goToBrochures();
  void goToDocuments();
  void goToBroadcast();
  void goToPrayerRoom();
  void goToMusic();
  void goToDevotional();
  void goToTransportation();
  void goToAccessibility();
  void goToSocialMedia();
  void goToTranslationChannel();

  Future<void> chooseLenguage({required Languages language});
  void routeToBy(SectionViewModel section);
  Future<void> loadDataSpiritual();
}
