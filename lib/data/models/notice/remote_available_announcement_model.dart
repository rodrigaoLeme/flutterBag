import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';

class RemoteAvailableAnnouncementModel {
  final String id;
  final String? parentAnnouncementId;
  final String? title;
  final String? editalNumber;
  final DateTime? editalReleaseDate;
  final int? educationLevel;
  final int? scholarshipType;
  final int? announcementType;
  final String? administrativeAcronym;
  final String? processTypeDescription;
  final ProcessPeriodEntity? processPeriod;
  final List<AnnouncementSchoolEntity> schools;
  final bool isPersonAuthorized;

  const RemoteAvailableAnnouncementModel({
    required this.id,
    this.parentAnnouncementId,
    this.title,
    this.editalNumber,
    this.editalReleaseDate,
    this.educationLevel,
    this.scholarshipType,
    this.announcementType,
    this.administrativeAcronym,
    this.processTypeDescription,
    this.processPeriod,
    this.schools = const [],
    this.isPersonAuthorized = false,
  });

  factory RemoteAvailableAnnouncementModel.fromJson(Map<String, dynamic> json) {
    final announcement = json['announcement'] as Map<String, dynamic>? ?? {};
    final processPeriodJson = json['processPeriod'] as Map<String, dynamic>?;
    final schoolsList = (json['schools'] as List?)
            ?.map((s) => AnnouncementSchoolEntity(
                  id: s['id'] as String,
                  name: s['name'] as String?,
                  city: s['city'] as String?,
                ))
            .toList() ??
        [];

    ProcessPeriodEntity? processPeriod;
    if (processPeriodJson != null) {
      processPeriod = ProcessPeriodEntity(
        id: processPeriodJson['id'] as String,
        registerStart: processPeriodJson['registerStart'] != null
            ? DateTime.tryParse(processPeriodJson['registerStart'] as String)
            : null,
        registerEnd: processPeriodJson['registerEnd'] != null
            ? DateTime.tryParse(processPeriodJson['registerEnd'] as String)
            : null,
        documentationUploadDeadLine:
            processPeriodJson['documentationUploadDeadLine'] != null
                ? DateTime.tryParse(
                    processPeriodJson['documentationUploadDeadLine'] as String)
                : null,
        documentationReturnUploadDeadLine:
            processPeriodJson['documentationReturnUploadDeadLine'] != null
                ? DateTime.tryParse(
                    processPeriodJson['documentationReturnUploadDeadLine']
                        as String)
                : null,
        resultRelease: processPeriodJson['resultRelease'] != null
            ? DateTime.tryParse(processPeriodJson['resultRelease'] as String)
            : null,
        resubmissionDays: processPeriodJson['resubmissionDays'] as int?,
      );
    }

    return RemoteAvailableAnnouncementModel(
      id: announcement['id'] as String,
      parentAnnouncementId: announcement['parentAnnouncementId'] as String?,
      title: announcement['title'] as String?,
      editalNumber: announcement['editalNumber'] as String?,
      editalReleaseDate: announcement['editalReleaseDate'] != null
          ? DateTime.tryParse(announcement['editalReleaseDate'] as String)
          : null,
      educationLevel: announcement['educationLevel'] as int?,
      scholarshipType: announcement['scholarshipType'] as int?,
      announcementType: announcement['announcementType'] as int?,
      administrativeAcronym: json['administrativeAcronym'] as String?,
      processTypeDescription: json['processTypeDescription'] as String?,
      processPeriod: processPeriod,
      schools: schoolsList,
      isPersonAuthorized: json['isPersonAuthorized'] as bool? ?? false,
    );
  }

  AvailableAnnouncementEntity toEntity() => AvailableAnnouncementEntity(
        id: id,
        title: title,
        editalNumber: editalNumber,
        editalReleaseDate: editalReleaseDate,
        educationLevel: EducationLevel.fromValue(educationLevel ?? 0),
        scholarshipType: ScholarshipType.fromValue(scholarshipType),
        announcementType: AnnouncementType.fromValue(announcementType),
        parentAnnouncementId: parentAnnouncementId,
        administrativeAcronym: administrativeAcronym,
        processTypeDescription: processTypeDescription,
        processPeriod: processPeriod,
        schools: schools,
        isPersonAuthorized: isPersonAuthorized,
      );
}
