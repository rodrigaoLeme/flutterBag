import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../data/models/notification/remote_notification_model.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import '../../helpers/extensions/extensions.dart';
import '../../helpers/extensions/string_extension.dart';

class NotificationViewModel {
  final List<NotificationResultViewModel>? notification;

  NotificationViewModel({
    required this.notification,
  });

  void markAdRead(NotificationResultViewModel item) {
    for (NotificationResultViewModel element in notification ?? []) {
      if (element.externalId == item.externalId) {
        element.isRead = true;
      }
    }
  }
}

class NotificationResultViewModel {
  final String? externalId;
  final String? title;
  final String? body;
  final NotificationTypeModel? notificationType;
  bool? isRead;
  final String? dateTime;

  NotificationResultViewModel({
    required this.externalId,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.isRead,
    required this.dateTime,
  });

  String get formatNotificationDate {
    final parsedDate = DateTime.tryParse(dateTime ?? '');
    if (parsedDate == null) return '';
    return parsedDate.dateHourUS;
  }

  String? get iconUrl => notificationType?.iconAsset;

  NotificationResultEntity toEntity() => NotificationResultEntity(
        externalId: externalId,
        title: title,
        body: body,
        icon: notificationType?.value,
        dateTime: dateTime,
      );

  double get heightFactor {
    final text = body ?? '';

    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 400);

    final estimatedHeight = textPainter.size.height;

    return estimatedHeight < 100 ? 0.25 : 0.6;
  }
}

class NotificationViewModelFactory {
  static Future<NotificationViewModel> make(
      RemoteNotificationModel? model,
      List<NotificationResultViewModel> currentNotifications,
      List<NotificationResultEntity>? notificationsRead) async {
    final notification = model?.notification != null
        ? await Future.wait(model!.notification!.map(
            (element) async => NotificationResultViewModel(
              externalId: element.externalId,
              title: await element.title.translate(),
              body: await element.body.translate(),
              notificationType: NotificationTypeModel.values.firstWhere(
                (elementNotification) =>
                    elementNotification.value == element.icon,
              ),
              isRead: notificationsRead?.firstWhereOrNull((elementRead) =>
                      elementRead.externalId == element.externalId) !=
                  null,
              dateTime: element.dateTime,
            ),
          ))
        : [];
    List<NotificationResultViewModel> allNotifications =
        NotificationViewModelFactory.removeSameItemById([
      ...notification,
      ...currentNotifications,
    ]);

    for (var item in allNotifications) {
      item.isRead = notificationsRead?.firstWhereOrNull(
              (elementRead) => elementRead.externalId == item.externalId) !=
          null;
    }
    return NotificationViewModel(notification: allNotifications);
  }

  static List<NotificationResultViewModel> removeSameItemById(
      List<NotificationResultViewModel> notificacoes) {
    final mapa = <String, NotificationResultViewModel>{};

    for (var n in notificacoes) {
      mapa[n.externalId ?? ''] = n;
    }

    return mapa.values.toList();
  }
}
