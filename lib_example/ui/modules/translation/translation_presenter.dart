import 'package:flutter/foundation.dart';

import '../../mixins/mixins.dart';
import 'translation_view_model.dart';

abstract class TranslationPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<TranslationViewModel?> get viewModel;
  ValueNotifier<bool?> get isFormEnable;

  Future<void> convinienceInit();
  Future<void> goToNavBar();
  void dispose();
  Future<void> chooseLenguage({required Languages language});
  void chooseEvent();
}
