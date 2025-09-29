import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../core/endpoints/endpoints.dart';
import '../../core/services/http_client/base/http_client.dart';
import '../../core/services/storage/hive/global_hive_initializer.dart';
import '../../core/services/storage/interface.dart';
import '../../core/stores/session/presenter/session_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initHttpClientAsync() {
    final endpoints = Modular.get<Endpoints>();
    Modular.get<HttpClient>().setBaseUrl(endpoints.base);
  }

  Future<void> initHiveForStoraging() {
    return Modular.get<GlobalHiveInitializer>().init();
  }

  Future<void> initTokenStorage() {
    return Modular.get<Storage>().init();
  }

  Future<void> initSessionStore() {
    return Modular.get<SessionStore>().init();
  }

  bool get isLogged => Modular.get<SessionStore>().isLogged;

  @override
  void initState() {
    super.initState();
    initHttpClientAsync();
    Future.wait([
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]),
      initHiveForStoraging(),
      initTokenStorage(),
      initSessionStore(),
    ]).then((_) {
      FlutterNativeSplash.remove();
      Modular.to.pushReplacementNamed(isLogged ? 'home/' : 'auth/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator.adaptive()
          ],
        ),
      ),
    );
  }
}
