import '../../../../presentation/presenters/push_notification_emergency/stream_push_notification_emergency_presenter.dart';
import '../../../../ui/modules/push_notification_emergency/push_notification_emergency_presenter.dart';
import '../../usecases/dashboard/load_notification_once_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/push_notification/load_current_notification_factory.dart';
import '../../usecases/push_notification/save_current_external_food_factory.dart';
import '../../usecases/push_notification/save_current_notification_type_factory.dart';

PushNotificationEmergencyPresenter makePushNotificationEmergencyPresenter() =>
    StreamPushNotificationEmergencyPresenter(
      saveCurrentScreenType: makeLocalSaveCurrentScreenType(),
      saveCurrentNotification: makeSaveCurrentNotification(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
      loadCurrentNotification: makeLoadCurrentNotification(),
      loadNotificationOnce: makeRemoteLoadNotificationOnce(),
    );
