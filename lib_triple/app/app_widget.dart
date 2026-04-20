import 'core/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = [
      'lib/app/core/i18n'
    ];

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'global_app_name'.i18n(),
      theme: lightTheme,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        LocalJsonLocalization.delegate
      ],
      localeResolutionCallback: (locale, locales) {
        return const Locale('pt', 'BR');
      },
    );
  }
}
