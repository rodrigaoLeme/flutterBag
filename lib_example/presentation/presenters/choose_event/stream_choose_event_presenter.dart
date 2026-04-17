import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/models/choose_event/remote_choose_event_model.dart';
import '../../../domain/usecases/event/load_active_events.dart';
import '../../../domain/usecases/event/save_current_event.dart';
import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../domain/usecases/translation/save_current_translation.dart';
import '../../../infra/firebase_cloud_message/firebase_cloud_message.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/extensions/date_formater_extension.dart';
import '../../../ui/helpers/extensions/string_extension.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/choose_event/choose_event_presenter.dart';
import '../../../ui/modules/choose_event/choose_event_view_model.dart';
import '../../../ui/modules/translation/translation_view_model.dart';
import '../../mixins/mixins.dart';
import '../globals/global_data.dart';

class StreamChooseEventPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements ChooseEventPresenter {
  final LoadActiveEvent loadActiveEvent;
  final SaveCurrentEvent saveCurrentEvent;
  final SaveCurrentTranslation saveCurrentTranslation;
  final LoadCurrentTranslation loadCurrentTranslation;

  StreamChooseEventPresenter({
    required this.loadActiveEvent,
    required this.saveCurrentEvent,
    required this.saveCurrentTranslation,
    required this.loadCurrentTranslation,
  });

  final StreamController<ChooseEventViewModel?> _viewModel =
      StreamController<ChooseEventViewModel?>.broadcast();
  @override
  Stream<ChooseEventViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true, style: LoadingStyle.primary);
      loadActiveEvent.load()?.listen(
        (document) async {
          try {
            final model = RemoteChooseEventModel.fromDocument(document);
            final votingViewModel =
                await ChooseEventViewModelFactory.make(model);
            if (votingViewModel.result.length == 1) {
              selectCurrentEvent(votingViewModel.result.first);
            } else {
              _viewModel.add(votingViewModel);
            }
          } catch (e) {
            _viewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {
          _viewModel.addError(error);
        },
      );
    } catch (error) {
      _viewModel.addError(error);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  Future<void> selectCurrentEvent(EventViewModel? event) async {
    try {
      isLoading = LoadingData(isLoading: true, style: LoadingStyle.primary);
      String hex = event?.eventColor ?? '00558C';
      hex = hex.replaceAll('#', '');
      Globals().primaryColor = hex.toColor();
      final FirebaseCloudMessage firebaseCloudMessage = FirebaseCloudMessage();
      final eventMap = event?.toMap();
      final json = jsonEncode(eventMap);
      await saveCurrentEvent.save(json);
      final languageType = await loadCurrentTranslation.load();
      if (languageType != null) {
        final selectedLanguage = Languages.values.firstWhere(
          (lang) => lang.type == languageType,
          orElse: () => Languages.en,
        );
        await setLocale(selectedLanguage.locale);
      }
      await FirebaseMessaging.instance.requestPermission();
      String? token;
      if (Platform.isIOS) {
        token = await FirebaseMessaging.instance.getAPNSToken();
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
      if (token != null) {
        await firebaseCloudMessage.unSubscribeTopics();
        await firebaseCloudMessage.subscribeTopics();
      }
      navigateTo = NavigationData(route: Routes.splash, clear: true);
    } catch (error) {
      navigateTo = NavigationData(route: Routes.splash, clear: true);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }
}
