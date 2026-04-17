import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main/factories/usecases/event/load_current_event_factory.dart';
import '../../main/factories/usecases/push_notification/save_current_notification_type_factory.dart';
import '../../presentation/mixins/push_fullscreen_manager.dart';
import '../local_push_notification/local_push_notification.dart';

class FirebaseCloudMessage {
  static final FirebaseCloudMessage _instance =
      FirebaseCloudMessage._internal();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late final LocalPushNotificationService _localPushNotificationService;

  FirebaseCloudMessage._internal() {
    _localPushNotificationService = LocalPushNotificationService();
  }

  factory FirebaseCloudMessage() {
    return _instance;
  }

  Future<void> init() async {
    await _localPushNotificationService.init();
    _configureMessaging();
  }

  void _configureMessaging() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    await FirebaseMessaging.instance.requestPermission();
    String? token;
    if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }

    if (token != null) {
      print('🔥 Token: $token');
      unawaited(subscribeTopics());
      handleInitialMessage();
    }

    _onMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
    onMessageOpenedApp();
  }

  Future<void> handleInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data['topic'] != null) {
      final topic = initialMessage?.data['topic'];
      if (topic == 'fullscreen') {
        final currentScreenType = makeLocalSaveCurrentScreenType();
        final json = jsonEncode(initialMessage?.toMap());
        currentScreenType.save(json);
        return;
      }
    }
  }

  Future<void> subscribeTopics() async {
    final loadCurrentEvent = makeLocalLoadCurrentEvent();
    final currentEvent = await loadCurrentEvent.load();
    final eventId = currentEvent?.externalId ?? '';
    await firebaseMessaging.subscribeToTopic('${eventId}_standard');
    await firebaseMessaging.subscribeToTopic('${eventId}_fullscreen');
  }

  Future<void> unSubscribeTopics() async {
    final loadCurrentEvent = makeLocalLoadCurrentEvent();
    final currentEvent = await loadCurrentEvent.load();
    final eventId = currentEvent?.externalId ?? '';
    await firebaseMessaging.unsubscribeFromTopic('${eventId}_standard');
    await firebaseMessaging.unsubscribeFromTopic('${eventId}_fullscreen');
  }

  void _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (message.data['topic'] != null) {
        final topic = message.data['topic'];
        if (topic == 'fullscreen') {
          PushFullscreenManager().isShowing = message;
        }
      }

      if (notification != null && android != null) {
        final localPushMessage = MetarPushNotificationMessage(
          id: android.hashCode,
          title: notification.title!,
          body: notification.body!,
        );

        _localPushNotificationService.showNotification(
            message: localPushMessage);
      }
    });
  }

  static Future<void> firebaseBackgroundMessageHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (message.data['topic'] != null) {
      final topic = message.data['topic'];
      if (topic == 'fullscreen') {
        PushFullscreenManager().isShowing = message;
      }
    }
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? iOS = message.notification?.apple;

    if (notification != null && (android != null || iOS != null)) {
      final localPushMessage = MetarPushNotificationMessage(
        id: (android ?? iOS!).hashCode,
        title: notification.title!,
        body: notification.body!,
      );

      FirebaseCloudMessage()
          ._localPushNotificationService
          .showNotification(message: localPushMessage);
    }
  }

  void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  void _goToPageAfterMessage(RemoteMessage message) {
    if (message.data['topic'] != null) {
      final topic = message.data['topic'];
      if (topic == 'fullscreen') {
        PushFullscreenManager().isShowing = message;
        return;
      }
    }
  }
}
