import '../../../domain/entities/scholarship_entity.dart';
import '../../../presentation/mixins/mixins.dart';

abstract class HomePresenter {
  Stream<List<int>> get yearsStream;
  Stream<List<ScholarshipEntity>> get scholarshipsStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<String?> get uiErrorStream;
  int get selectedYear;

  Future<void> loadInitialData();
  Future<void> onYearSelected(int year);
  void dispose();
}
