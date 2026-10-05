import 'announcement_enums.dart';
import 'authorization_capabilities_entity.dart';
import 'authorization_stage_entity.dart';
import 'scholarship_process_period_entity.dart';

class ScholarshipEntity {
  final String id;
  final int academicYear;
  final int? currentStep;
  final int? completedStep;
  final DateTime? finishedOnUtc;
  final DateTime? canceledOnUtc;
  final String? processPeriodId;
  final ProcessType? processType;
  final ApplicantScholarshipStatus? status;
  final ScholarshipStatus? scholarshipStatus;
  final DateTime createdOnUtc;
  final int declassificationType;
  final String? administrativeAcronym;
  final String? announcementId;
  final String? announcementTitle;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;
  final int? registrationSequence;
  final String? timeZone;
  final ScholarshipProcessPeriodEntity? processPeriod;
  final AuthorizationCapabilitiesEntity? authorizationCapabilities;

  const ScholarshipEntity({
    required this.id,
    required this.academicYear,
    this.currentStep,
    this.completedStep,
    this.finishedOnUtc,
    this.canceledOnUtc,
    this.processPeriodId,
    this.processType,
    this.status,
    this.scholarshipStatus,
    required this.createdOnUtc,
    this.declassificationType = 0,
    this.administrativeAcronym,
    this.announcementId,
    this.announcementTitle,
    this.educationLevel,
    this.scholarshipType,
    this.registrationSequence,
    this.timeZone,
    this.processPeriod,
    this.authorizationCapabilities,
  });

  static bool _hasDate(DateTime? date) => date != null && date.year > 1;

  // Inscrição somente leitura — não pode retomar
  bool get isReadOnly =>
      _hasDate(finishedOnUtc) ||
      completedStep == 6 ||
      _hasDate(canceledOnUtc) ||
      declassificationType != 0;

  // Stage relevante baseado no completedStep
  AuthorizationStageEntity? get relevantStage =>
      authorizationCapabilities?.stageFor(completedStep);

  // Data do banner — effectiveDeadline do stage relevante
  DateTime? get bannerDeadline => relevantStage?.effectiveDeadline;

  String? get effectiveProcessPeriodId =>
      (processPeriodId != null && processPeriodId!.isNotEmpty)
          ? processPeriodId
          : processPeriod?.id;

  bool get canContinue => !isReadOnly;

  // Rótulo do botão de continuar
  String get continueLabel => (completedStep != null && completedStep! >= 4)
      ? 'Enviar documentação'
      : 'Continuar inscrição';

  // Step para navegar ao retomar: currentStep == null ? 1 : currentStep + 1
  int get resumeStep => currentStep == null ? 1 : currentStep! + 1;

  bool get isFinished => finishedOnUtc != null;
  bool get isInProgress =>
      status == ApplicantScholarshipStatus.registrationInProgress;
}
