import 'package:intl/intl.dart';

class MoneyFormatter {
  const MoneyFormatter._();

  static String format(dynamic value) {
    try {
      if (value == null) return '';
      if (value is num) {
        return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
            .format(value);
      }
      if (value is String) {
        final parsed = parse(value);
        return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
            .format(parsed);
      }
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }

  static double parse(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9,\.]'), '');
      final normalized = cleaned.replaceAll(',', '.');
      return double.tryParse(normalized) ?? 0;
    }
    return 0;
  }
}
