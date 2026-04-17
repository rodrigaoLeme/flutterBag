class NotificationEntity {
  final List<NotificationResultEntity>? notification;

  NotificationEntity({
    required this.notification,
  });

  Map toJson() => {
        'Result': notification?.map((element) => element.toJson()).toList(),
      };
}

class NotificationResultEntity {
  final String? externalId;
  final String? title;
  final String? body;
  final int? icon;
  final String? dateTime;

  NotificationResultEntity({
    required this.externalId,
    required this.title,
    required this.body,
    required this.icon,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'ExternalId': externalId,
        'Title': title,
        'Body': body,
        'Icon': icon,
        'DateTime': dateTime,
      };
}
