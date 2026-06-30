import 'dart:ui';

import '../../main/i18n/app_i18n.dart';

final appStrings = AppI18n.current;

enum ProcessSteps {
  initial(1),
  register(2),
  documentation(3),
  verification(4),
  analysis(5),
  completed(6);

  const ProcessSteps(this.value);
  final int value;

  static ProcessSteps fromValue(int? value) {
    try {
      return ProcessSteps.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return initial;
    }
  }

  String get label {
    switch (this) {
      case initial:
        return appStrings.processStepsInitial;
      case register:
        return appStrings.processStepsSecond;
      case documentation:
        return appStrings.processStepsThird;
      case verification:
        return appStrings.processStepsVerification;
      case analysis:
        return appStrings.processStepsFifth;
      case completed:
        return appStrings.processStepsCompleted;
    }
  }

  Color get color {
    switch (this) {
      case initial:
        return const Color(0xFF45EEFF);
      case register:
        return const Color(0xFFF9AB73);
      case documentation:
        return const Color(0xFFFFC421);
      case verification:
        return const Color(0xFFFF63D8);
      case analysis:
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
