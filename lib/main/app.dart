import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../ui/helpers/themes/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'e-Bolsa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: Modular.routerConfig,
    );
  }
}
