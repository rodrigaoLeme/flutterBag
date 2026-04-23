import 'i18n/app_i18n.dart';

enum FlavorType { dev, prod }

class Flavor {
  Flavor._();

  static late FlavorType flavorType;

  static bool get isDev => flavorType == FlavorType.dev;
  static bool get isProd => flavorType == FlavorType.prod;

  static String get apiBaseUrl {
    switch (flavorType) {
      case FlavorType.dev:
        return 'https://api-ebolsa-dev.educadventista.org';
      case FlavorType.prod:
        return 'https://api-ebolsa.educadventista.org';
    }
  }

  static String get appName {
    final appStrings = AppI18n.current;

    switch (flavorType) {
      case FlavorType.dev:
        return appStrings.appNameDev;
      case FlavorType.prod:
        return appStrings.appNameProd;
    }
  }
}
