import '../../../../presentation/presenters/choose_event/stream_choose_event_presenter.dart';
import '../../../../ui/modules/choose_event/choose_event_presenter.dart';
import '../../usecases/event/choose_event_factory.dart';
import '../../usecases/event/save_current_event_factory.dart';
import '../../usecases/translation/load_current_translation_factory.dart';
import '../../usecases/translation/save_current_translation_factory.dart';

ChooseEventPresenter makeChooseEventPresenter() => StreamChooseEventPresenter(
      loadActiveEvent: makeRemoteLoadActiveEvent(),
      saveCurrentEvent: makeSaveCurrentEvent(),
      saveCurrentTranslation: makeSaveCurrentTranslation(),
      loadCurrentTranslation: makeLoadCurrentTranslation(),
    );
