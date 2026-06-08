import 'announcement_enums.dart';

class ProcessPeriodAvailableEntity {
  final String id;
  final ProcessType? processType;
  final DateTime? registerStart;
  final DateTime? registerEnd;
  final DateTime? documentationUploadDeadLine;
  final DateTime? documentationReturnUploadDeadLine;
  final DateTime? resultRelease;
  final int? resubmissionDays;
  final String? announcementTitle;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;

  const ProcessPeriodAvailableEntity({
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

  bool get isRegistrationOpen {
    final now = DateTime.now();
    if (registerStart == null || registerEnd == null) return false;
    return now.isAfter(registerStart!) && now.isBefore(registerEnd!);
  }

  String get registerPeriodLabel {
    if (registerStart == null || registerEnd == null) return '-';
    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return 'Até ${fmt(registerEnd!)}';
  }
}
