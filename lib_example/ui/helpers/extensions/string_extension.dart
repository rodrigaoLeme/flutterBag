import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../main/factories/usecases/translation/load_current_translation_factory.dart';
import '../../modules/translation/translation_view_model.dart';

final _translator = GoogleTranslator();

extension StringTranslation on String {
  Future<String> translate({String to = 'en'}) async {
    if (FeatureFlags().isTranslateEnable() &&
        FeatureFlags().isRealTimeTranslationEnable()) {
      try {
        final LoadCurrentTranslation loadCurrentTranslation =
            makeLoadCurrentTranslation();
        final lenguageString = await loadCurrentTranslation.load();
        final lenguage = Languages.values
            .firstWhereOrNull((element) => element.type == lenguageString);
        final translated = await _translator.translate(
          this,
          to: lenguage?.type ?? to,
        );
        return translated.text;
      } catch (_) {
        return this;
      }
    } else {
      return this;
    }
  }

  Future<String> translateSections({String to = 'en'}) async {
    if (FeatureFlags().isTranslateEnable()) {
      try {
        final LoadCurrentTranslation loadCurrentTranslation =
            makeLoadCurrentTranslation();
        final lenguageString = await loadCurrentTranslation.load();
        final lenguage = Languages.values
            .firstWhereOrNull((element) => element.type == lenguageString);
        final translated = await _translator.translate(
          this,
          to: lenguage?.type ?? to,
        );
        return translated.text;
      } catch (_) {
        return this;
      }
    } else {
      return this;
    }
  }

  Future<String> translateMenu({String to = 'en'}) async {
    if (FeatureFlags().isTranslateEnable() &&
        FeatureFlags().isMenuTranslationEnable()) {
      try {
        final LoadCurrentTranslation loadCurrentTranslation =
            makeLoadCurrentTranslation();
        final lenguageString = await loadCurrentTranslation.load();
        final lenguage = Languages.values
            .firstWhereOrNull((element) => element.type == lenguageString);
        final translated = await _translator.translate(
          this,
          to: lenguage?.type ?? to,
        );
        return translated.text;
      } catch (_) {
        return this;
      }
    } else {
      return this;
    }
  }

  String get formatToSentenceString {
    return replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
  }

  String get getExtensionFile {
    RegExp regex = RegExp(r'\.(\w+)$');
    Match? match = regex.firstMatch(this);
    if (match != null) {
      return match.group(1) ?? '';
    } else {
      return '';
    }
  }

  String get socialIcon {
    if (contains('facebook.com')) {
      return 'lib/ui/assets/images/icon/facebook.svg';
    } else if (contains('instagram.com')) {
      return 'lib/ui/assets/images/icon/instagram_icon.svg';
    } else if (contains('youtube.com') || contains('youtu.be')) {
      return 'lib/ui/assets/images/icon/youtube_icon.svg';
    } else if (contains('x.com') || contains('twitter.com')) {
      return 'lib/ui/assets/images/icon/x_twitter_icon.svg';
    } else if (contains('linkedin.com')) {
      return 'lib/ui/assets/images/icon/linkedin_icon.svg';
    } else {
      return 'lib/ui/assets/images/icon/link_icon.svg';
    }
  }

  DateTime? get toEnDate {
    return DateTime.tryParse(this);
  }

  String get formatImagByWordPress {
    String html = this;
    if (contains('data-wpfc-original-src')) {
      html = html.replaceAll('data-wpfc-original-src', 'src');
      html = html.replaceAll(
          'src=\'https://adventistreview.org/wp-content/plugins/wp-fastest-cache-premium/pro/images/blank.gif',
          '');
      html = html.replaceAll('<img', '<img height="540" width="540"');
    }

    return html;
  }

  String get normalizarUrl {
    String url = this;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    if (!url.endsWith('/')) {
      url = '$url/';
    }

    return url;
  }

  Color toColor({Color fallback = Colors.grey}) {
    final hex = replaceAll('#', '').trim().toUpperCase();
    final fullHex = hex.length == 6 ? 'FF$hex' : hex;

    final isValid = RegExp(r'^[0-9A-F]{8}$').hasMatch(fullHex);
    if (!isValid) {
      return fallback;
    }

    return Color(int.parse(fullHex, radix: 16));
  }

  DateTime? parseDateWithTimezone({
    required String timezoneOffsetStr,
  }) {
    final naive = DateTime.tryParse(this);
    final offset = parseTimezoneOffset(timezoneOffsetStr);

    return naive?.subtract(offset).toUtc();
  }

  Duration parseTimezoneOffset(String tzStr) {
    final match = RegExp(r'([+-])(\d{2}):(\d{2})').firstMatch(tzStr);
    if (match != null) {
      final sign = match.group(1) == '-' ? -1 : 1;
      final hours = int.parse(match.group(2) ?? '00');
      final minutes = int.parse(match.group(3) ?? '00');
      return Duration(hours: hours * sign, minutes: minutes * sign);
    }
    return Duration.zero;
  }

  String extractVideoId() {
    final uri = Uri.tryParse(this);
    if (uri == null) return '';

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? '';
    }

    if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }

    if (uri.pathSegments.contains('live')) {
      final liveIndex = uri.pathSegments.indexOf('live');
      if (liveIndex != -1 && liveIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[liveIndex + 1];
      }
    }

    return '';
  }
}
