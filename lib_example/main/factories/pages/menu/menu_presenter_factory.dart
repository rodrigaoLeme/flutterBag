import '../../../../presentation/presenters/menu/stream_menu_presenter.dart';
import '../../../../ui/modules/menu/menu_presenter.dart';
import '../../usecases/dashboard/load_section_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/menu/remote_menu_factory.dart';
import '../../usecases/push_notification/load_current_notification_type_factory.dart';
import '../../usecases/spiritual/load_spiritual_factory.dart';
import '../../usecases/translation/load_current_translation_factory.dart';
import '../../usecases/translation/save_current_translation_factory.dart';

MenuPresenter makeMenuPresenter() => StreamMenuPresenter(
      loadMenu: makeRemoteLoadMenu(),
      loadSection: makeRemoteLoadSection(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadCurrentScreenType: makeLocalLoadCurrentScreenType(),
      saveCurrentTranslation: makeSaveCurrentTranslation(),
      loadCurrentTranslation: makeLoadCurrentTranslation(),
      loadSpiritual: makeRemoteLoadSpiritual(),
    );
