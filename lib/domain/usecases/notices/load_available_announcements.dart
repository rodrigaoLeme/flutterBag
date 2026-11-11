import '../../entities/announcement_enums.dart';
import '../../entities/available_announcement_entity.dart';

class LoadAvailableAnnouncementsParams {
  final String year;
  final String? city;
  final String? schoolId;
  final ProcessType processType;
  final EducationLevel? educationLevel;

  const LoadAvailableAnnouncementsParams({
    required this.year,
    this.city,
    this.schoolId,
    required this.processType,
    this.educationLevel,
  });
}

abstract class LoadAvailableAnnouncementsUsecase {
  Future<List<AvailableAnnouncementEntity>> load(
      LoadAvailableAnnouncementsParams params);
}
