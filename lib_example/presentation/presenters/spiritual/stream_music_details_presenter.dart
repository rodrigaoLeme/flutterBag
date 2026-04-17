import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../ui/modules/spiritual/music/details/music_details_presenter.dart';
import '../../../ui/modules/spiritual/music_view_model.dart';
import '../../mixins/mixins.dart';

class StreamMusicDetailsPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements MusicDetailsPresenter {
  final StreamController<MusicViewModel?> _viewModel =
      StreamController<MusicViewModel?>.broadcast();
  @override
  Stream<MusicViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      final musicViewModel = Modular.args.data as MusicViewModel;
      _viewModel.add(musicViewModel);
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }
}
