import 'package:firebase_remote_config/firebase_remote_config.dart';

class FeatureFlags {
  static final FeatureFlags _instance = FeatureFlags._internal();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String featureTranslate = 'feature_translate';
  static const String featureReloadEvent = 'feature_reload_event';
  static const String featureDailyBulletinBanner =
      'feature_daily_bulletin_banner';
  static const String featureExhibitorsSchedule = 'feature_exhibitors_schedule';
  static const String featureRealTimeTranslation =
      'feature_real_time_translation';
  static const String featureMenuTranslation = 'feature_real_menu_translation';

  factory FeatureFlags() {
    return _instance;
  }

  FeatureFlags._internal();

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));

    await _remoteConfig.setDefaults({
      featureTranslate: true,
    });
    await fetchFeatureFlags();
  }

  Future<void> fetchFeatureFlags() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Erro ao buscar Feature Flags: $e');
    }
  }

  bool isTranslateEnable() => _remoteConfig.getBool(featureTranslate);
  bool isReloadEvent() => _remoteConfig.getBool(featureReloadEvent);
  String getDailyBulletinBannerUrl() =>
      _remoteConfig.getString(featureDailyBulletinBanner);
  String getfeatureExhibitorsSchedule() =>
      _remoteConfig.getString(featureExhibitorsSchedule);
  bool isRealTimeTranslationEnable() =>
      _remoteConfig.getBool(featureRealTimeTranslation);
  bool isMenuTranslationEnable() =>
      _remoteConfig.getBool(featureMenuTranslation);
}
