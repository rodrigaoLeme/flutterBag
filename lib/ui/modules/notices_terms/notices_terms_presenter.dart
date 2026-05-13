import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';
import '../../../domain/entities/school_entity.dart';
import 'notices_terms_view_model.dart';

abstract class NoticesTermsPresenter {
  Stream<NoticesTermsViewModel> get viewModelStream;
  Stream<List<NoticeEntity>> get noticesStream;

  void loadInitialData();
  Future<void> loadSchools(String year);
  List<SchoolEntity> getUnitsForCity(String city);
  Future<void> fetchNotices({
    required String year,
    required String city,
    required String schoolId,
    EducationLevel? educationLevel,
  });
  void clearNotices();
  void dispose();
}
