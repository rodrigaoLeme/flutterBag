import 'announcement_enums.dart';

class AdditiveTermEntity {
  final String id;
  final String title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final EducationLevel? educationLevel;
  final ProcessType? processType;
  final ScholarshipType? scholarshipType;
  final String noticeId;

  const AdditiveTermEntity(
      {required this.id,
      required this.title,
      this.editalNumber,
      this.editalReleaseDate,
      this.educationLevel,
      this.processType,
      this.scholarshipType,
      required this.noticeId});
}

class NoticeEntity {
  final String id;
  final String title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final EducationLevel? educationLevel;
  final ProcessType? processType;
  final ScholarshipType? scholarshipType;
  final List<AdditiveTermEntity> additiveTerms;

  const NoticeEntity({
    required this.id,
    required this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.processType,
    this.scholarshipType,
    this.additiveTerms = const [],
  });

  String get processTypeLabel => processType?.label ?? '';
  String get scholarshipTypeLabel => scholarshipType?.label ?? '';
  String get educationLevelLabel => educationLevel?.label ?? '';
}
