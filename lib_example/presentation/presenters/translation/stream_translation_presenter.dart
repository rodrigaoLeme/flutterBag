import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../domain/usecases/translation/save_current_translation.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/extensions/date_formater_extension.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/translation/translation_presenter.dart';
import '../../../ui/modules/translation/translation_view_model.dart';
import '../../mixins/mixins.dart';

class StreamTranslationPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements TranslationPresenter {
  final SaveCurrentTranslation saveCurrentTranslation;
  final LoadCurrentTranslation loadCurrentTranslation;

  final StreamController<TranslationViewModel?> _viewModel =
      StreamController<TranslationViewModel?>.broadcast();
  @override
  Stream<TranslationViewModel?> get viewModel => _viewModel.stream;

  final ValueNotifier<bool?> _isFormEnable = ValueNotifier<bool?>(null);
  @override
  ValueNotifier<bool?> get isFormEnable => _isFormEnable;

  StreamTranslationPresenter({
    required this.saveCurrentTranslation,
    required this.loadCurrentTranslation,
  });

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 10));
      final isTranslateEnable = FeatureFlags().isTranslateEnable();

      _viewModel.add(
        TranslationViewModel(
            currentLanguage: null, isTranslateEnable: isTranslateEnable),
      );
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> goToNavBar() async {
    try {
      final language = await loadCurrentTranslation.load();
      if (language != null) {
        navigateTo = NavigationData(route: Routes.splash, clear: true);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> chooseLenguage({required Languages language}) async {
    try {
      await saveCurrentTranslation.save(language.type);
      await setLocale(language.locale);
      _isFormEnable.value = true;
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  void chooseEvent() {
    navigateTo = NavigationData(
      route: Routes.chooseEvent,
      clear: true,
    );
  }
}
