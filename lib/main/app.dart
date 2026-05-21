import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../share/session_events.dart';
import '../ui/helpers/themes/themes.dart';
import 'di/injection_container.dart';
import 'i18n/app_i18n.dart';
import 'routes/auth_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _sessionSubscription = sl<SessionEvents>().onSessionExpired.listen(
      (_) {
        Modular.to.navigate(AuthRoutes.login);
      },
    );
  }

  @override
  void dispose() {
    _sessionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return MaterialApp.router(
      title: appStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: Modular.routerConfig,
    );
  }
}
