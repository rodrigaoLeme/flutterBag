import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../ui/modules/spiritual/devotional/devotional_presenter.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../mixins/mixins.dart';

class StreamDevotionalPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements DevotionalPresenter {
  final StreamController<SpiritualViewModel?> _viewModel =
      StreamController<SpiritualViewModel?>.broadcast();

  @override
  Stream<SpiritualViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      final spiritualViewModel = Modular.args.data as SpiritualViewModel;

      _viewModel.add(spiritualViewModel);
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  void filterBy({
    required DevotionalFilter filter,
    required SpiritualViewModel spiritualViewModel,
    required DevotionalDayPeriod type,
  }) {
    spiritualViewModel.setupInitialFilter(filter, type);
    _viewModel.add(spiritualViewModel);
  }

  @override
  void setCurrentLanguageFilter({
    required DevotionalLanguages filter,
    required DevotionalDayPeriod type,
    required SpiritualViewModel spiritualViewModel,
  }) {
    spiritualViewModel.setCurrentLanguageFilter(filter, type);
    _viewModel.add(spiritualViewModel);
  }
}
