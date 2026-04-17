import '../../../../presentation/presenters/notification/stream_notification_presenter.dart';
import '../../../../ui/modules/notification/notification_presenter.dart';
import '../../usecases/dashboard/load_notification_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/push_notification/load_current_notification_factory.dart';
import '../../usecases/push_notification/save_current_external_food_factory.dart';

NotificationPresenter makeNotificationPresenter() =>
    StreamNotificationPresenter(
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadNotification: makeRemoteLoadNotification(),
      loadCurrentNotification: makeLoadCurrentNotification(),
      saveCurrentNotification: makeSaveCurrentNotification(),
    );
