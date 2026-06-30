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

enum ResultStatus {
  analysis(1),
  approved50(2),
  approved100(3),
  rejected(4),
  disqualified(5),
  waitingList(6);

  const ResultStatus(this.value);
  final int value;

  static ResultStatus fromValue(int? value) {
    try {
      return ResultStatus.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return waitingList;
    }
  }

  String get label {
    switch (this) {
      case analysis:
        return appStrings.resultStatusAnalysis;
      case approved50:
        return appStrings.resultStatusApproved50;
      case approved100:
        return appStrings.resultStatusApproved100;
      case rejected:
        return appStrings.resultStatusRejected;
      case disqualified:
        return appStrings.resultStatusDisqualified;
      case waitingList:
        return appStrings.resultStatusWaitingList;
    }
  }

  Color get color {
    switch (this) {
      case analysis:
        return const Color(0xFFFFC421);
      case approved50:
        return const Color(0xFF45EEFF);
      case approved100:
        return const Color(0xFF7DD6A1);
      case rejected:
        return const Color(0xFFFF4B5D);
      case disqualified:
        return const Color(0xFFF9AB73);
      case waitingList:
        return const Color(0xFFA496FF);
    }
  }
}

enum RegistrationStatus {
  noRegistration(1),
  reserveSpot(2),
  registered(3),
  completed(4),
  locked(5),
  withdrawal(6),
  canceled(7),
  awaitingApproval(8),
  transferred(9);

  const RegistrationStatus(this.value);
  final int value;

  static RegistrationStatus fromValue(int? value) {
    try {
      return RegistrationStatus.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return noRegistration;
    }
  }

  String get label {
    switch (this) {
      case noRegistration:
        return appStrings.registrationStatusNoRegistration;
      case reserveSpot:
        return appStrings.registrationStatusReserveSpot;
      case registered:
        return appStrings.registrationStatusRegistered;
      case completed:
        return appStrings.registrationStatusCompleted;
      case locked:
        return appStrings.registrationStatusLocked;
      case withdrawal:
        return appStrings.registrationStatusWithdrawal;
      case canceled:
        return appStrings.registrationStatusCanceled;
      case awaitingApproval:
        return appStrings.registrationStatusAwaitingApproval;
      case transferred:
        return appStrings.registrationStatusTransferred;
    }
  }

  Color get color {
    switch (this) {
      case noRegistration:
        return const Color(0xFFE0E2EC);
      case reserveSpot:
        return const Color(0xFFFFC421);
      case registered:
        return const Color(0xFF5EEBD4);
      case completed:
        return const Color(0xFF7DD6A1);
      case locked:
        return const Color(0xFFEF4800);
      case withdrawal:
        return const Color(0xFFC02B2B);
      case canceled:
        return const Color(0xFF800020);
      case awaitingApproval:
        return const Color(0xFFCD5C5C);
      case transferred:
        return const Color(0xFF5C1579);
    }
  }
}
