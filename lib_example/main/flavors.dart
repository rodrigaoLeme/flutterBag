enum FlavorTypes {
  dev,
  prod,
  sandbox,
  staging,
}

class Flavor {
  Flavor._instance();

  static late FlavorTypes flavorType;

  static String get flavorMessage {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'Dev';
      case FlavorTypes.prod:
        return 'Production';
      case FlavorTypes.sandbox:
        return 'Sandbox';
      case FlavorTypes.staging:
        return 'Staging';
    }
  }

  static String get apiBaseUrl {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'https://api-gc-dev.sdasystems.org/';
      case FlavorTypes.prod:
        return 'https://api-gc.sdasystems.org/';
      case FlavorTypes.staging:
        return 'https://api-gc-staging.sdasystems.org/';
      case FlavorTypes.sandbox:
        return 'https://api-gc-sandbox.sdasystems.org/';
    }
  }
}
