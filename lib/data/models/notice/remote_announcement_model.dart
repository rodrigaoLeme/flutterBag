import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';

class RemoteAnnouncementModel {
  final String id;
  final String? parentAnnouncementId;
  final String? title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final int? educationLevel;
  final int? processType;
  final int? scholarshipType;
  final int? announcementType;

  const RemoteAnnouncementModel({
    required this.id,
    this.parentAnnouncementId,
    this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.processType,
    this.scholarshipType,
    this.announcementType,
  });

  factory RemoteAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return RemoteAnnouncementModel(
      id: json['announcement']['id'] as String,
      parentAnnouncementId:
          json['announcement']['parentAnnouncementId'] as String?,
      title: json['announcement']?['title'] as String?,
      editalNumber: json['announcement']['editalNumber'] as String?,
      editalReleaseDate: json['announcement']['editalReleaseDate'] != null
          ? DateTime.tryParse(
              json['announcement']['editalReleaseDate'] as String)
          : null,
      educationLevel: json['announcement']['educationLevel'] as int?,
      processType: json['processPeriods'].first['processType'] as int?,
      scholarshipType: json['announcement']['scholarshipType'] as int?,
      announcementType: json['announcement']['announcementType'] as int?,
    );
  }

  bool get isEdital => announcementType == 1;

  AdditiveTermEntity toAdditiveTerm(String noticeId) => AdditiveTermEntity(
        id: id,
        title: title ?? '',
        editalNumber: editalNumber,
        editalReleaseDate: editalReleaseDate,
        educationLevel: EducationLevel.fromValue(educationLevel),
        processType: ProcessType.fromValue(processType),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
        noticeId: noticeId,
      );

  NoticeEntity toEntity() => NoticeEntity(
        id: id,
        title: title ?? '',
        editalNumber: editalNumber,
        editalReleaseDate: editalReleaseDate,
        educationLevel: EducationLevel.fromValue(educationLevel),
        processType: ProcessType.fromValue(processType),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
      );
}
