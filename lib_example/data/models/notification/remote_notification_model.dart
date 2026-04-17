import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../domain/entities/notification/notification_entity.dart';
import '../../http/http.dart';

class RemoteNotificationModel {
  final List<NotificationResultModel>? notification;

  RemoteNotificationModel({
    required this.notification,
  });

  factory RemoteNotificationModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final notification = decodedResult
          .map((item) =>
              NotificationResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteNotificationModel(notification: notification);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  factory RemoteNotificationModel.fromJson(Map json) {
    if (!json.containsKey('Result')) {
      throw HttpError.invalidData;
    }
    return RemoteNotificationModel(
      notification: json['Result']
          .map<NotificationResultModel>(
            (resultEventJson) =>
                NotificationResultModel.fromJson(resultEventJson),
          )
          .toList(),
    );
  }

  NotificationEntity toEntity() => NotificationEntity(
        notification: notification
            ?.map<NotificationResultEntity>(
              (event) => event.toEntity(),
            )
            .toList(),
      );
}

class NotificationResultModel {
  final String? externalId;
  final String title;
  final String body;
  final int? icon;
  final String? dateTime;

  NotificationResultModel({
    required this.externalId,
    required this.title,
    required this.body,
    required this.icon,
    required this.dateTime,
  });

  factory NotificationResultModel.fromJson(Map json) {
    if (!json.containsKey('Title')) {
      throw HttpError.invalidData;
    }

    return NotificationResultModel(
      externalId: json['ExternalId'],
      title: json['Title'],
      body: json['Body'],
      icon: json['Icon'],
      dateTime: json['DateTime'],
    );
  }

  RemoteMessage toRemoteNotification() => RemoteMessage(
        messageId: externalId,
        data: toEntity().toJson(),
        notification: RemoteNotification(
          title: title,
          body: body,
        ),
      );

  NotificationResultEntity toEntity() => NotificationResultEntity(
        externalId: externalId,
        title: title,
        body: body,
        icon: icon,
        dateTime: dateTime,
      );
}

enum NotificationTypeModel {
  fullscreen(0),
  standard(1),
  byEvent(2);

  const NotificationTypeModel(this.value);
  final int value;

  String get iconAsset {
    switch (this) {
      case NotificationTypeModel.fullscreen:
        return 'lib/ui/assets/images/icon/bell-ring-regular.svg';
      case NotificationTypeModel.standard:
        return 'lib/ui/assets/images/icon/megaphone-regular.svg';
      case NotificationTypeModel.byEvent:
        return 'lib/ui/assets/images/icon/schedule_light.svg';
    }
  }
}
