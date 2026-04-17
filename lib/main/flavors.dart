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
    switch (flavorType) {
      case FlavorType.dev:
        return 'e-BolsaDev';
      case FlavorType.prod:
        return 'e-Bolsa';
    }
  }
}
