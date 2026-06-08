import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/process_period_entity.dart';

class RemoteProcessPeriodModel {
  final String id;
  final int? processType;
  final DateTime? registerStart;
  final DateTime? registerEnd;
  final DateTime? documentationUploadDeadLine;
  final DateTime? documentationReturnUploadDeadLine;
  final DateTime? resultRelease;
  final int? resubmissionDays;
  final String? announcementTitle;
  final int? educationLevel;
  final int? scholarshipType;

  const RemoteProcessPeriodModel({
    required this.id,
    this.processType,
    this.registerStart,
    this.registerEnd,
    this.documentationUploadDeadLine,
    this.documentationReturnUploadDeadLine,
    this.resultRelease,
    this.resubmissionDays,
    this.announcementTitle,
    this.educationLevel,
    this.scholarshipType,
  });

  factory RemoteProcessPeriodModel.fromJson(Map<String, dynamic> json) =>
      RemoteProcessPeriodModel(
        id: json['id'] as String,
        processType: json['processType'] as int?,
        registerStart: json['registerStart'] != null
            ? DateTime.tryParse(json['registerStart'] as String)
            : null,
        registerEnd: json['registerEnd'] != null
            ? DateTime.tryParse(json['registerEnd'] as String)
            : null,
        documentationUploadDeadLine: json['documentationUploadDeadLine'] != null
            ? DateTime.tryParse(json['documentationUploadDeadLine'] as String)
            : null,
        documentationReturnUploadDeadLine:
            json['documentationReturnUploadDeadLine'] != null
                ? DateTime.tryParse(
                    json['documentationReturnUploadDeadLine'] as String)
                : null,
        resultRelease: json['resultRelease'] != null
            ? DateTime.tryParse(json['resultRelease'] as String)
            : null,
        resubmissionDays: json['resubmissionDays'] as int?,
        announcementTitle: json['announcementTitle'] as String?,
        educationLevel: json['educationLevel'] as int?,
        scholarshipType: json['scholarshipType'] as int?,
      );

  ProcessPeriodAvailableEntity toEntity() => ProcessPeriodAvailableEntity(
        id: id,
        processType: ProcessType.fromValue(processType),
        registerStart: registerStart,
        registerEnd: registerEnd,
        documentationUploadDeadLine: documentationUploadDeadLine,
        documentationReturnUploadDeadLine: documentationReturnUploadDeadLine,
        resultRelease: resultRelease,
        resubmissionDays: resubmissionDays,
        announcementTitle: announcementTitle,
        educationLevel: EducationLevel.fromValue(educationLevel ?? 0),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
      );
}
