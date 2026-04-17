// import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../infra/firebase/feature_flag.dart';
import '../infra/firebase_cloud_message/firebase_cloud_message.dart';
import './app.dart';
import 'app_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );

  unawaited(FirebaseCloudMessage().init());
  unawaited(FeatureFlags().init());
}
