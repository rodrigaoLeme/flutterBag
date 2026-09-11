import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/authorization_capabilities_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../domain/entities/scholarship_process_period_entity.dart';

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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static ScholarshipEntity fromJson(Map<String, dynamic> json) {
    ScholarshipProcessPeriodEntity? processPeriod;
    if (json['processPeriod'] != null) {
      processPeriod = ScholarshipProcessPeriodEntity.fromJson(
        Map<String, dynamic>.from(json['processPeriod'] as Map),
      );
    }

    AuthorizationCapabilitiesEntity? authCaps;
    if (json['authorizationCapabilities'] != null) {
      authCaps = AuthorizationCapabilitiesEntity.fromJson(
        Map<String, dynamic>.from(json['authorizationCapabilities'] as Map),
      );
    }

    return ScholarshipEntity(
      id: json['id'] as String,
      academicYear: _parseInt(json['academicYear']) ?? 0,
      currentStep: _parseInt(json['currentStep']),
      completedStep: _parseInt(json['completedStep']),
      finishedOnUtc: _parseDateTime(json['finishedOnUtc']),
      canceledOnUtc: _parseDateTime(json['canceledOnUtc']),
      processPeriodId: json['processPeriodId'] as String?,
      processType: ProcessType.fromValue(_parseInt(json['processType'])),
      status: ApplicantScholarshipStatus.fromValue(_parseInt(json['status'])),
      scholarshipStatus:
          ScholarshipStatus.fromValue(_parseInt(json['scholarshipStatus'])),
      createdOnUtc: DateTime.parse(json['createdOnUtc'] as String),
      declassificationType: _parseInt(json['declassificationType']) ?? 0,
      administrativeAcronym: json['administrativeAcronym'] as String?,
      announcementId: json['announcementId'] as String?,
      announcementTitle: json['announcementTitle'] as String?,
      educationLevel:
          EducationLevel.fromValue(_parseInt(json['educationLevel']) ?? 0),
      scholarshipType:
          ScholarshipType.fromValue(_parseInt(json['scholarshipType'])),
      registrationSequence: _parseInt(json['registrationSequence']),
      timeZone: json['timeZone'] as String?,
      processPeriod: processPeriod,
      authorizationCapabilities: authCaps,
    );
  }

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
