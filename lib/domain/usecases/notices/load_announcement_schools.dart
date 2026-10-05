import '../../entities/announcement_enums.dart';
import '../../entities/available_announcement_entity.dart';

class LoadAnnouncementSchoolsParams {
  final String? announcementId;
  final String? processPeriodId;
  final int year;
  final EducationLevel? educationLevel;
  final List<AnnouncementSchoolEntity> knownSchools;

  const LoadAnnouncementSchoolsParams({
    this.announcementId,
    this.processPeriodId,
    required this.year,
    this.educationLevel,
    this.knownSchools = const [],
  });
}

abstract class LoadAnnouncementSchoolsUsecase {
  Future<List<AnnouncementSchoolEntity>> load(
    LoadAnnouncementSchoolsParams params,
  );
}
