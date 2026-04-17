import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../main/routes/routes_app.dart';
import '../../../ui/modules/spiritual/music/music_presenter.dart';
import '../../../ui/modules/spiritual/music_view_model.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../mixins/mixins.dart';

class StreamMusicPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements MusicPresenter {
  final StreamController<MusicListViewModel?> _viewModel =
      StreamController<MusicListViewModel?>.broadcast();
  @override
  Stream<MusicListViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      final spiritualViewModel = Modular.args.data as SpiritualViewModel;
      _viewModel.add(
        MusicListViewModel(
          musics: spiritualViewModel.music ?? [],
        ),
      );
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  void goToMusicDetails({required MusicViewModel musicViewModel}) {
    Modular.to.pushNamed(
      Routes.musicDetails,
      arguments: musicViewModel,
    );
  }

  @override
  void filterBy(String text, MusicListViewModel viewModel) {
    viewModel.filterBy(text);
    _viewModel.add(viewModel);
  }
}
