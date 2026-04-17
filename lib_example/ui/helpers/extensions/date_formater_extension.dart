import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../i18n/resources.dart';

extension HumanDateTime on DateTime {
  static String humanDate({required DateTime dateTime}) {
    final formattedDate =
        DateFormat('dd/MM/yyyy', Intl.defaultLocale).format(dateTime);
    final formattedHour =
        DateFormat('HH:mm', Intl.defaultLocale).format(dateTime);
    return '$formattedDate ${R.string.labelAs} $formattedHour';
  }
}

extension DateTimeYearMonthDay on DateTime {
  static String yearMonthDay({required DateTime dateTime}) {
    return DateFormat('yyyy/MM/dd', Intl.defaultLocale).format(dateTime);
  }
}

extension DateTimeDayMonthYear on DateTime {
  static String dayMontYear({required DateTime dateTime}) {
    return DateFormat('dd/MM/yyyy', Intl.defaultLocale).format(dateTime);
  }
}

extension DateTimeEn on DateTime {
  String get dayToStringEn {
    return DateFormat('yyyy-MM-dd', Intl.defaultLocale).format(this);
  }

  String get dayMonthYear {
    return DateFormat('dd/MM/yyyy', Intl.defaultLocale).format(this);
  }

  String get dayMonth {
    return DateFormat('dd/MM', Intl.defaultLocale).format(this);
  }

  String get toFormattedTime {
    return DateFormat('h:mm a', Intl.defaultLocale).format(this);
  }

  String get dateHour {
    return DateFormat.yMMMd(Intl.defaultLocale).add_jm().format(this);
  }

  String get dateHourUS {
    final formattedDate =
        DateFormat('MM/dd/yyyy', Intl.defaultLocale).format(this);
    final formattedHour =
        DateFormat('hh:mm a', Intl.defaultLocale).format(this);
    return '$formattedDate ${R.string.labelAs} $formattedHour';
  }
}

extension DateTimeWithHour on DateTime {
  String get dateWithHour {
    return DateFormat.yMMMMd(Intl.defaultLocale).add_Hm().format(this);
  }

  String get completeDate {
    return DateFormat('d MMMM yyyy', Intl.defaultLocale).format(this);
  }

  String get dateMonthYear {
    return DateFormat('MMMM d-M, yyyy', Intl.defaultLocale).format(this);
  }

  String get dateDayAndMonthName {
    return DateFormat('dd MMM', Intl.defaultLocale).format(this);
  }

  String get timeAgo {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
    final now = DateTime.now();
    final difference = now.difference(this);
    return timeago.format(DateTime.now().subtract(difference),
        locale: Intl.defaultLocale);
  }

  String get completeDatewithHour {
    final formattedDate =
        DateFormat('dd/MMMM', Intl.defaultLocale).format(this);
    final formattedHour = DateFormat('HH:mm', Intl.defaultLocale).format(this);
    return '$formattedDate ${R.string.labelAs} $formattedHour';
  }

  String get completeHour {
    return DateFormat('HH:mm', Intl.defaultLocale).format(this);
  }

  String get filterDate {
    return DateFormat('EE, MMM dd', Intl.defaultLocale).format(this);
  }

  String get weekdayMonth {
    return DateFormat('EEEE, MMMM d', Intl.defaultLocale).format(this);
  }
}

extension DateTimeFormatting on DateTime {
  String format() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays == 2) {
      return 'Anteontem';
    } else {
      return DateFormat('dd/MM', Intl.defaultLocale).format(this);
    }
  }
}

extension MonthName on DateTime {
  String get monthNameShort {
    return DateFormat('MMM', Intl.defaultLocale).format(this);
  }
}

extension WeekName on DateTime {
  String get weekDayName {
    return DateFormat('EEE', Intl.defaultLocale).format(this);
  }
}

extension MonthWIthYearName on DateTime {
  String get dateWithMonthYear {
    return DateFormat('MMM/yyyy', Intl.defaultLocale).format(this);
  }
}

extension MonthToNumber on String {
  int toMonthNumber() {
    final months = List.generate(12, (i) {
      return DateFormat('MMMM', Intl.defaultLocale).format(DateTime(0, i + 1));
    });
    int index = months.indexWhere((m) => m.toLowerCase() == toLowerCase());
    return index != -1 ? index + 1 : 0;
  }
}

extension MonthToName on int {
  String toMonthName({bool shortName = false}) {
    final format = shortName ? 'MMM' : 'MMMM';
    return DateFormat(format, Intl.defaultLocale).format(DateTime(0, this));
  }
}

extension MonthExtension on String {
  int get monthNumber => toMonthNumber();
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

Future<void> setLocale(String locale) async {
  final intlLocale = switch (locale) {
    'pt_BR' => 'pt_BR',
    'en' => 'en_US',
    'es' => 'es_ES',
    'fr' => 'fr_FR',
    'ru' => 'ru_RU',
    _ => 'en_US',
  };

  await initializeDateFormatting(intlLocale, null);
  Intl.defaultLocale = intlLocale;

  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('ru', timeago.RuMessages());
  timeago.setDefaultLocale(locale);
}
