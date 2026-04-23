import 'dart:convert';

import '../../main/i18n/app_i18n.dart';

class JwtDecoder {
  JwtDecoder._();

  static Map<String, dynamic> decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw FormatException(AppI18n.current.jwtInvalidToken);
      }
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      throw FormatException(AppI18n.current.jwtDecodeError(e));
    }
  }

  static bool isExpired(String token) {
    try {
      final payload = decode(token);
      final exp = payload['exp'];
      if (exp == null) return false;
      return DateTime.now().isAfter(
        DateTime.fromMillisecondsSinceEpoch((exp as int) * 1000),
      );
    } catch (_) {
      return true;
    }
  }
}
