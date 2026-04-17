import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/spiritual/remote_spiritual_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/spiritual/load_spiritual.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/modules/spiritual/spiritual_presenter.dart';
import '../../../ui/modules/spiritual/spiritual_view_model.dart';
import '../../mixins/mixins.dart';

class StreamSpiritualPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements SpiritualPresenter {
  LoadSpiritual loadSpiritual;
  LoadCurrentEvent loadCurrentEvent;

  StreamSpiritualPresenter({
    required this.loadSpiritual,
    required this.loadCurrentEvent,
  });
  final StreamController<SpiritualViewModel?> _viewModel =
      StreamController<SpiritualViewModel?>.broadcast();
  @override
  Stream<SpiritualViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadSpiritual
          .load(
        params: LoadSpiritualParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteSpiritualModel.fromDocument(document);
            final spiritualViewModel =
                await SpiritualViewModelFactory.make(model);
            _viewModel.add(spiritualViewModel);
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
    }
  }

  @override
  void goToPrayerRoom({required PrayerRoomViewModel? prayerRoomViewModel}) {
    Modular.to.pushNamed(
      Routes.prayerRoom,
      arguments: prayerRoomViewModel,
    );
  }

  @override
  void goToMusic({required SpiritualViewModel? spiritualViewModel}) {
    Modular.to.pushNamed(
      Routes.music,
      arguments: spiritualViewModel,
    );
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  void goToDevotional({required SpiritualViewModel? spiritualViewModel}) {
    Modular.to.pushNamed(
      Routes.devotional,
      arguments: spiritualViewModel,
    );
  }
}
