import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../ui/modules/spiritual/prayer_room/prayer_room_presenter.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../mixins/mixins.dart';

class StreamPrayerRoomPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements PrayerRoomPresenter {
  final StreamController<PrayerRoomViewModel?> _viewModel =
      StreamController<PrayerRoomViewModel?>.broadcast();
  @override
  Stream<PrayerRoomViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      final prayerRoomViewModel = Modular.args.data as PrayerRoomViewModel;
      _viewModel.add(prayerRoomViewModel);
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }
}
