import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../data/models/notification/remote_notification_model.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/push_notification/load_current_notification.dart';
import '../../../domain/usecases/push_notification/load_notification.dart';
import '../../../domain/usecases/push_notification/save_current_notification.dart';
import '../../../ui/modules/notification/notification_presenter.dart';
import '../../../ui/modules/notification/notification_view_model.dart';
import '../../mixins/mixins.dart';

class StreamNotificationPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements NotificationPresenter {
  final LoadNotification loadNotification;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentNotification loadCurrentNotification;
  final SaveCurrentNotification saveCurrentNotification;

  StreamNotificationPresenter({
    required this.loadNotification,
    required this.loadCurrentEvent,
    required this.saveCurrentNotification,
    required this.loadCurrentNotification,
  });

  final StreamController<NotificationViewModel?> _viewModel =
      StreamController<NotificationViewModel?>.broadcast();
  @override
  Stream<NotificationViewModel?> get viewModel => _viewModel.stream;
  List<NotificationResultViewModel> currentNotifications = [];

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();

      final notificationsRead = await loadNotificationRead();
      loadNotification
          .load(
              params: LoadNotificationParams(
        eventId: currentEvent?.externalId ?? '',
      ))
          ?.listen(
        (document) async {
          try {
            final model = RemoteNotificationModel.fromDocument(document);
            final notificationViewModel =
                await NotificationViewModelFactory.make(
              model,
              currentNotifications,
              notificationsRead,
            );
            currentNotifications = [
              ...currentNotifications,
              ...notificationViewModel.notification ?? [],
            ];
            _viewModel.add(notificationViewModel);
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

  @override
  Future<List<NotificationResultEntity>?> loadNotificationRead() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final notifications = await loadCurrentNotification.load(
        params: LoadCurrentNotificationParams(
            eventId: currentEvent?.externalId ?? ''),
      );
      return notifications?.notification;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveNotificationRead({
    required NotificationResultViewModel viewModel,
    required NotificationViewModel? notificationViewModel,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final notificationEntity = viewModel.toEntity();
      final List<NotificationResultEntity> notificationRead =
          await loadNotificationRead() ?? [];
      if (notificationRead.firstWhereOrNull(
              (element) => element.externalId == viewModel.externalId) ==
          null) {
        notificationRead.add(notificationEntity);
      }
      final notifications = NotificationEntity(notification: notificationRead);
      final notificationMap = notifications.toJson();
      final json = jsonEncode(notificationMap);
      await saveCurrentNotification.save(
          params: SaveCurrentNotificationParams(
              eventId: currentEvent?.externalId ?? '', data: json));
      notificationViewModel?.markAdRead(viewModel);
      _viewModel.add(notificationViewModel);
    } catch (error) {
      return;
    }
  }
}
