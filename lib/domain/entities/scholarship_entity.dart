import 'announcement_enums.dart';

class ScholarshipEntity {
  final String id;
  final int academicYear;
  final int? currentStep;
  final int? completedStep;
  final DateTime? finishedOnUtc;
  final String? processPeriodId;
  final ProcessType? processType;
  final ApplicantScholarshipStatus? status;
  final ScholarshipStatus? scholarshipStatus;
  final DateTime createdOnUtc;

  const ScholarshipEntity({
    required this.id,
    required this.academicYear,
    this.currentStep,
    this.completedStep,
    this.finishedOnUtc,
    this.processPeriodId,
    this.processType,
    this.status,
    this.scholarshipStatus,
    required this.createdOnUtc,
  });

  bool get isFinished => finishedOnUtc != null;
  bool get isInProgress =>
      status == ApplicantScholarshipStatus.registrationInProgress;
}
