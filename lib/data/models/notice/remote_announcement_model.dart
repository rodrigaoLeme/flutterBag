import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';

class RemoteAnnouncementModel {
  final String id;
  final String? parentAnnouncementId;
  final String? title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final int educationLevel;
  final int? scholarshipType;
  final int? announcementType;
  final String? processTypeDescription;

  const RemoteAnnouncementModel({
    required this.id,
    this.parentAnnouncementId,
    this.title,
    this.editalNumber,
    this.editalReleaseDate,
    required this.educationLevel,
    this.scholarshipType,
    this.announcementType,
    this.processTypeDescription,
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
      educationLevel: json['announcement']['educationLevel'] as int,
      scholarshipType: json['announcement']['scholarshipType'] as int?,
      announcementType: json['announcement']['announcementType'] as int?,
      processTypeDescription: json['processTypeDescription'] as String?,
    );
  }

  bool get isEdital => announcementType == 1;

  AdditiveTermEntity toAdditiveTerm(String noticeId) => AdditiveTermEntity(
        id: id,
        title: title ?? '',
        editalNumber: editalNumber,
        editalReleaseDate: editalReleaseDate,
        educationLevel: EducationLevel.fromValue(educationLevel),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
        noticeId: noticeId,
        processTypeDescription: processTypeDescription ?? '',
      );

  NoticeEntity toEntity() => NoticeEntity(
        id: id,
        title: title ?? '',
        editalNumber: editalNumber,
        editalReleaseDate: editalReleaseDate,
        educationLevel: EducationLevel.fromValue(educationLevel),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
        processTypeDescription: processTypeDescription ?? '',
      );
}
