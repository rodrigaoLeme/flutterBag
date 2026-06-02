import '../../entities/scholarship_form_entity.dart';

abstract class LoadScholarshipFormUsecase {
  Future<ScholarshipFormEntity?> load(String processPeriodId);
}
