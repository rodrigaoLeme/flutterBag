import '../../../../presentation/presenters/translation_channel/stream_translation_channel_presenter.dart';
import '../../../../ui/modules/translation_channel/translation_channel_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/translation_channel/load_translation_channel_factory.dart';

TranslationChannelPresenter makeTranslationChannelPresenter() =>
    StreamTranslationChannelPresenter(
      loadTranslationChannel: makeRemoteLoadTranslationChannel(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
