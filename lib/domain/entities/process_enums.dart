import 'dart:ui';

import '../../main/i18n/app_i18n.dart';

final appStrings = AppI18n.current;

enum ProcessSteps {
  initial,
  second,
  third,
  verification,
  fifth,
  completed;

  String get label {
    switch (this) {
      case initial:
        return appStrings.processStepsInitial;
      case second:
        return appStrings.processStepsSecond;
      case third:
        return appStrings.processStepsThird;
      case verification:
        return appStrings.processStepsVerification;
      case fifth:
        return appStrings.processStepsFifth;
      case completed:
        return appStrings.processStepsCompleted;
    }
  }

  Color get color {
    switch (this) {
      case initial:
        return const Color(0xFF45EEFF);
      case second:
        return const Color(0xFFF9AB73);
      case third:
        return const Color(0xFFFFC421);
      case verification:
        return const Color(0xFFFF63D8);
      case fifth:
        return const Color(0xFFA496FF);
      case completed:
        return const Color(0xFF7DD6A1);
    }
  }
}

enum ProcessesType {
  renewProcess,
  newProcess;

  String get label {
    switch (this) {
      case renewProcess:
        return appStrings.renewProcess;
      case newProcess:
        return appStrings.newProcess;
    }
  }
}

enum ProcessesBanner {
  warning,
  pending,
  error,
}
