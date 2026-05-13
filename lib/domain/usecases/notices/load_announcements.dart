import '../../entities/announcement_enums.dart';
import '../../entities/notice_entity.dart';

class LoadAnnouncementsParams {
  final String year;
  final String city;
  final String schoolId;
  final int? processType;
  final EducationLevel? educationLevel;

  const LoadAnnouncementsParams({
    required this.year,
    required this.city,
    required this.schoolId,
    this.processType,
    this.educationLevel,
  });
}

abstract class LoadAnnouncementsUsecase {
  Future<List<NoticeEntity>> load(LoadAnnouncementsParams params);
}
