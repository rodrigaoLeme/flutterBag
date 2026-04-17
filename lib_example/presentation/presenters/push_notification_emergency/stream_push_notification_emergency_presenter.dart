import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../data/models/notification/remote_notification_model.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/push_notification/load_current_notification.dart';
import '../../../domain/usecases/push_notification/load_notification_once.dart';
import '../../../domain/usecases/push_notification/save_current_notification.dart';
import '../../../domain/usecases/push_notification/save_current_screen_type.dart';
import '../../../ui/modules/push_notification_emergency/push_notification_emergency_presenter.dart';

class StreamPushNotificationEmergencyPresenter
    implements PushNotificationEmergencyPresenter {
  final SaveCurrentScreenType saveCurrentScreenType;
  final SaveCurrentNotification saveCurrentNotification;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentNotification loadCurrentNotification;
  final LoadNotificationOnce loadNotificationOnce;
  RemoteNotificationModel? model;

  StreamPushNotificationEmergencyPresenter({
    required this.saveCurrentScreenType,
    required this.saveCurrentNotification,
    required this.loadCurrentEvent,
    required this.loadCurrentNotification,
    required this.loadNotificationOnce,
  });

  @override
  Future<void> convinienceInit() async {
    try {
      await saveCurrentScreenType.save(null);
      final currentEvent = await loadCurrentEvent.load();

      final document = await loadNotificationOnce.load(
          params: LoadNotificationOnceParams(
              eventId: currentEvent?.externalId ?? ''));
      if (document != null) {
        model = RemoteNotificationModel.fromDocument(document);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<NotificationResultModel?> saveNotificationRead({
    required NotificationResultEntity? notificationRead,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();

      List<NotificationResultEntity> notificationsRead =
          await loadNotificationRead() ?? [];
      final alreadyAdd = notificationsRead.any(
        (read) => read.externalId == notificationRead?.externalId,
      );
      if (notificationRead != null && !alreadyAdd) {
        notificationsRead.add(notificationRead);
      }
      final notifications = NotificationEntity(notification: notificationsRead);
      final notificationMap = notifications.toJson();
      final json = jsonEncode(notificationMap);
      await saveCurrentNotification.save(
          params: SaveCurrentNotificationParams(
              eventId: currentEvent?.externalId ?? '', data: json));
      notificationsRead = await loadNotificationRead() ?? [];
      final unReadMessage =
          model?.notification?.firstWhereOrNull((notification) {
        final isRead = notificationsRead.any(
          (read) => read.externalId == notification.externalId,
        );

        return !isRead && notification.icon == 0;
      });
      return unReadMessage;
    } catch (error) {
      return null;
    }
  }

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
}
