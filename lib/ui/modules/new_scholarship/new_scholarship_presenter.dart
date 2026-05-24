import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/school_entity.dart';
import 'new_scholarship_view_model.dart';

abstract class NewScholarshipPresenter {
  Stream<NewScholarshipViewModel> get viewModelStream;
  Stream<List<AvailableAnnouncementEntity>> get announcementsStream;

  void loadInitialData(int lockedYear);
  Future<void> loadSchools(String year);
  List<SchoolEntity> getUnitsForCity(String cityState);
  Future<void> fetchAnnouncements({
    required String year,
    required String city,
    required String schoolId,
    EducationLevel? educationLevel,
  });
  void clearAnnouncements();
  void dispose();
}
