import 'package:collection/collection.dart';

import '../../../data/models/choose_event/remote_choose_event_model.dart';
import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/usecases/event/load_active_events_once.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/extensions/string_extension.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/choose_event/choose_event_view_model.dart';
import '../../../ui/modules/splash/splash_presenter.dart';
import '../../../ui/modules/translation/translation_view_model.dart';
import '../../mixins/mixins.dart';
import '../globals/global_data.dart';

class StreamSplashPresenter with NavigationManager implements SplashPresenter {
  final LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentTranslation loadCurrentTranslation;
  final LoadActiveEventOnce loadActiveEvent;

  StreamSplashPresenter({
    required this.loadCurrentEvent,
    required this.loadCurrentTranslation,
    required this.loadActiveEvent,
  });

  @override
  Future<void> checkAccount() async {
    try {
      final event = await loadCurrentEvent.load();
      String hex = event?.eventColor ?? '00558C';
      hex = hex.replaceAll('#', '');

      Globals().primaryColor = hex.toColor();
      final isTranslateEnable = FeatureFlags().isTranslateEnable();
      if (isTranslateEnable) {
        final lenguageString = await loadCurrentTranslation.load();
        final lenguage = Languages.values
            .firstWhereOrNull((element) => element.type == lenguageString);
        if (lenguage == null) {
          R.load(Languages.en);
          navigateTo = NavigationData(route: Routes.translation, clear: true);
        } else if (event != null) {
          final activeEvent = await loadData(event);
          if (activeEvent?.externalId == event.externalId) {
            String hex = activeEvent?.eventColor ?? '00558C';
            hex = hex.replaceAll('#', '');

            Globals().primaryColor = hex.toColor();
            R.load(lenguage);
            navigateTo = NavigationData(route: Routes.navBar, clear: true);
          } else {
            R.load(Languages.en);
            navigateTo = NavigationData(route: Routes.translation, clear: true);
          }
        } else {
          R.load(Languages.en);
          navigateTo = NavigationData(route: Routes.translation, clear: true);
        }
      } else if (event == null) {
        R.load(Languages.en);
        navigateTo = NavigationData(route: Routes.translation, clear: true);
      } else {
        final activeEvent = await loadData(event);
        if (activeEvent?.externalId == event.externalId) {
          String hex = activeEvent?.eventColor ?? '00558C';
          hex = hex.replaceAll('#', '');

          Globals().primaryColor = hex.toColor();
          R.load(Languages.en);
          navigateTo = NavigationData(route: Routes.navBar, clear: true);
        } else {
          R.load(Languages.en);
          navigateTo = NavigationData(route: Routes.translation, clear: true);
        }
      }
    } catch (error) {
      R.load(Languages.en);
      navigateTo = NavigationData(route: Routes.navBar, clear: true);
    }
  }

  Future<EventViewModel?> loadData(EventResultEntity? event) async {
    try {
      try {
        final document = await loadActiveEvent.load();
        if (document != null) {
          final model = RemoteChooseEventModel.fromDocument(document);
          final chooseEventViewModel =
              await ChooseEventViewModelFactory.make(model);
          return chooseEventViewModel.result.firstWhereOrNull(
              (element) => element.externalId == event?.externalId);
        }
        return null;
      } catch (e) {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
