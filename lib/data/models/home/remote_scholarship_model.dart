import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/scholarship_entity.dart';

class RemoteScholarshipModel {
  final String id;
  final int academicYear;
  final int? currentStep;
  final int? completedStep;
  final DateTime? finisheOnUtc;
  final String? processPeriodId;
  final int? processType;
  final int scholarshipStatus;
  final int status;
  final DateTime createdOnUtc;

  const RemoteScholarshipModel({
    required this.id,
    required this.academicYear,
    this.currentStep,
    this.completedStep,
    this.finisheOnUtc,
    this.processPeriodId,
    this.processType,
    required this.scholarshipStatus,
    required this.status,
    required this.createdOnUtc,
  });

  factory RemoteScholarshipModel.fromJson(Map<String, dynamic> json) =>
      RemoteScholarshipModel(
        id: json['id'] as String,
        academicYear: json['academicYear'] as int,
        currentStep: json['currentStep'] as int?,
        completedStep: json['completedStep'] as int?,
        finisheOnUtc: json['finisheOnUtc'] != null
            ? DateTime.tryParse(json['finisheOnUtc'] as String)
            : null,
        processPeriodId: json['processPeriodId'] as String?,
        processType: json['processType'] as int?,
        scholarshipStatus: json['scholarshipStatus'] as int,
        status: json['status'] as int,
        createdOnUtc: DateTime.parse(json['createdOnUtc'] as String),
      );

  ScholarshipEntity toEntity() => ScholarshipEntity(
        id: id,
        academicYear: academicYear,
        currentStep: currentStep,
        completedStep: completedStep,
        finishedOnUtc: finisheOnUtc,
        processPeriodId: processPeriodId,
        processType: ProcessType.fromValue(processType),
        status: ApplicantScholarshipStatus.fromValue(status),
        scholarshipStatus: ScholarshipStatus.fromValue(scholarshipStatus),
        createdOnUtc: createdOnUtc,
      );
}
