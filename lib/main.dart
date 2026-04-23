import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main/app.dart';
import 'main/di/injection_container.dart';
import 'main/routes/app_module.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flavor já foi definido pelo entrypoint (main_dev/main_prod) antes desta
  // chamada, portanto setupInjection() já enxerga o apiBaseUrl correto.
  setupInjection();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(ModularApp(module: AppModule(), child: const App()));
}
