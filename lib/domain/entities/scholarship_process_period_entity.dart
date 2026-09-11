import 'announcement_enums.dart';

class ScholarshipProcessPeriodEntity {
  final String id;
  final ProcessType? processType;
  final DateTime? registerStart;
  final DateTime? registerEnd;
  final DateTime? documentationUploadDeadLine;
  final DateTime? documentationReturnUploadDeadLine;
  final DateTime? supplementaryDocumentDeadline;
  final DateTime? resultRelease;
  final int? resubmissionDays;
  final String? announcementId;
  final String? announcementTitle;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;

  const ScholarshipProcessPeriodEntity({
    required this.id,
    this.processType,
    this.registerStart,
    this.registerEnd,
    this.documentationUploadDeadLine,
    this.documentationReturnUploadDeadLine,
    this.supplementaryDocumentDeadline,
    this.resultRelease,
    this.resubmissionDays,
    this.announcementId,
    this.announcementTitle,
    this.educationLevel,
    this.scholarshipType,
  });

  factory ScholarshipProcessPeriodEntity.fromJson(Map<String, dynamic> json) =>
      ScholarshipProcessPeriodEntity(
        id: json['id'] as String,
        processType: ProcessType.fromValue(_parseInt(json['processType'])),
        registerStart: _parseDate(json['registerStart']),
        registerEnd: _parseDate(json['registerEnd']),
        documentationUploadDeadLine:
            _parseDate(json['documentationUploadDeadLine']),
        documentationReturnUploadDeadLine:
            _parseDate(json['documentationReturnUploadDeadLine']),
        supplementaryDocumentDeadline:
            _parseDate(json['supplementaryDocumentDeadline']),
        resultRelease: _parseDate(json['resultRelease']),
        resubmissionDays: _parseInt(json['resubmissionDays']),
        announcementId: json['announcementId'] as String?,
        announcementTitle: json['announcementTitle'] as String?,
        educationLevel:
            EducationLevel.fromValue(_parseInt(json['educationLevel']) ?? 0),
        scholarshipType:
            ScholarshipType.fromValue(_parseInt(json['scholarshipType'])),
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  String get registerPeriodLabel {
    if (registerStart == null || registerEnd == null) return '-';
    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return 'Até ${fmt(registerEnd!)}';
  }
}
