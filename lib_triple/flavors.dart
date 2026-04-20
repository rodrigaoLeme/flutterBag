enum FlavorTypes { dev, prod }

class Flavor {
  Flavor._instance();

  static late FlavorTypes flavorType;

  static String get flavorMessage {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'Dev';
      case FlavorTypes.prod:
        return 'Production';
    }
  }

  static String get apiBaseUrl {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'https://api-ebolsa-dev.educadventista.org';
      case FlavorTypes.prod:
        return 'https://api-ebolsa.educadventista.org';
    }
  }

  static bool isProduction() => flavorType == FlavorTypes.prod;
  static bool isDevelopment() => flavorType == FlavorTypes.dev;
}
