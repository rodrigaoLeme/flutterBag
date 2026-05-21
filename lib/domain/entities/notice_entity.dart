import 'announcement_enums.dart';

class AdditiveTermEntity {
  final String id;
  final String title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;
  final String noticeId;
  final String? processTypeDescription;

  const AdditiveTermEntity({
    required this.id,
    required this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.scholarshipType,
    required this.noticeId,
    this.processTypeDescription,
  });
}

class NoticeEntity {
  final String id;
  final String title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final EducationLevel? educationLevel;
  final ScholarshipType? scholarshipType;
  final List<AdditiveTermEntity> additiveTerms;
  final String? processTypeDescription;

  const NoticeEntity({
    required this.id,
    required this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.scholarshipType,
    this.additiveTerms = const [],
    this.processTypeDescription,
  });

  String get processTypeLabel => processTypeDescription ?? '';
  String get scholarshipTypeLabel => scholarshipType?.label ?? '';
  String get educationLevelLabel => educationLevel?.label ?? '';
}
