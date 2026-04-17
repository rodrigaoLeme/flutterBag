import 'dart:async';

import '../../../data/models/translation_channel/remote_translation_channel_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/translation_channel/load_translation_channel.dart';
import '../../../ui/modules/translation_channel/translation_channel_presenter.dart';
import '../../../ui/modules/translation_channel/translation_channel_view_model.dart';
import '../../mixins/mixins.dart';

class StreamTranslationChannelPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements TranslationChannelPresenter {
  final LoadTranslationChannel loadTranslationChannel;
  LoadCurrentEvent loadCurrentEvent;

  StreamTranslationChannelPresenter({
    required this.loadTranslationChannel,
    required this.loadCurrentEvent,
  });

  final StreamController<TranslationChannelViewModel?> _viewModel =
      StreamController<TranslationChannelViewModel?>.broadcast();
  @override
  Stream<TranslationChannelViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      loadTranslationChannel
          .load(
        params: LoadTranslationChannelParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteTranslationChannelModel.fromDocument(document);
            final translationChannelViewModel =
                await TranslationChannelViewModelFactory.make(model);
            _viewModel.add(translationChannelViewModel);
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
  void dispose() {
    _viewModel.close();
  }
}
