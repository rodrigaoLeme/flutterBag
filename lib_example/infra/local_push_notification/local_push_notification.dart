import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotificationService {
  static final LocalPushNotificationService _instance =
      LocalPushNotificationService._internal();

  factory LocalPushNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin pushNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  LocalPushNotificationService._internal();

  Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    pushNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await pushNotificationPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(
      {required MetarPushNotificationMessage message}) async {
    final androidMessageShowDetails = AndroidNotificationDetails(
      'reminders_channel',
      message.title ?? '',
      channelDescription: 'Este é um canal para lembretes',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const iOSMessageShowDetails = DarwinNotificationDetails(
      presentBanner: true,
      presentSound: true,
    );

    pushNotificationPlugin.show(
      message.id,
      message.title,
      message.body,
      NotificationDetails(
        android: androidMessageShowDetails,
        iOS: iOSMessageShowDetails,
      ),
    );
  }

  Future<void> checkForNotifications() async {
    final details =
        await pushNotificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectedNotification(payload: details.notificationResponse?.payload);
    }
  }

  _onSelectedNotification({String? payload}) async {
    if (payload != null && payload.isNotEmpty) {}
  }
}

class MetarPushNotificationMessage {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  MetarPushNotificationMessage({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}
