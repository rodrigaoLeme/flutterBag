import 'announcement_enums.dart';

class AnnouncementSchoolEntity {
  final String id;
  final String? name;
  final String? city;

  const AnnouncementSchoolEntity({
    required this.id,
    this.name,
    this.city,
  });
}

class ProcessPeriodEntity {
  final String id;
  final DateTime? registerStart;
  final DateTime? registerEnd;
  final DateTime? documentationUploadDeadLine;
  final DateTime? documentationReturnUploadDeadLine;
  final DateTime? resultRelease;
  final int? resubmissionDays;

  const ProcessPeriodEntity({
    required this.id,
    this.registerStart,
    this.registerEnd,
    this.documentationUploadDeadLine,
    this.documentationReturnUploadDeadLine,
    this.resultRelease,
    this.resubmissionDays,
  });

  bool get isRegistrationOpen {
    final now = DateTime.now();
    if (registerStart == null || registerEnd == null) return false;
    return now.isAfter(registerStart!) && now.isBefore(registerEnd!);
  }
}

class AvailableAnnouncementEntity {
  final String id;
  final String? title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;
  final AnnouncementType? announcementType;
  final String? parentAnnouncementId;
  final String? administrativeAcronym;
  final String? processTypeDescription;
  final ProcessPeriodEntity? processPeriod;
  final List<AnnouncementSchoolEntity> schools;
  final bool isPersonAuthorized;

  const AvailableAnnouncementEntity({
    required this.id,
    this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.scholarshipType,
    this.announcementType,
    this.parentAnnouncementId,
    this.administrativeAcronym,
    this.processTypeDescription,
    this.processPeriod,
    this.schools = const [],
    this.isPersonAuthorized = false,
  });

  bool get isEdital => announcementType == AnnouncementType.edital;

  // Regra do botão para Solicitar Bolsa
  bool get canApply {
    if (processPeriod == null) return false;
    return (isPersonAuthorized || processPeriod!.isRegistrationOpen);
  }

  // Testa se está dentro do período de inscrição
  bool get isActive => processPeriod?.isRegistrationOpen ?? false;
}
