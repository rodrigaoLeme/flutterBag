import 'dart:async';

import '../../../domain/entities/scholarship_entity.dart';
import '../../../domain/usecases/home/load_home_data_usecase.dart';
import '../../../domain/usecases/home/load_year_scholarships_usecase.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/home/home_presenter.dart';
import '../../mixins/mixins.dart';

class StreamHomePresenter
    with LoadingManager, UIErrorManager
    implements HomePresenter {
  final LoadHomeDataUsecase loadHomeData;
  final LoadYearScholarshipsUsecase loadYearScholarships;

  StreamHomePresenter({
    required this.loadHomeData,
    required this.loadYearScholarships,
  });

  final _yearsController = StreamController<List<int>>.broadcast();
  final _scholarshipsController =
      StreamController<List<ScholarshipEntity>>.broadcast();

  @override
  Stream<List<int>> get yearsStream => _yearsController.stream;

  @override
  Stream<List<ScholarshipEntity>> get scholarshipsStream =>
      _scholarshipsController.stream;

  int _selectedYear = 0;

  @override
  int get selectedYear => _selectedYear;

  @override
  Future<void> loadInitialData() async {
    isLoading = LoadingData(isLoading: true);

    try {
      final data = await loadHomeData.load();

      if (data.years.isNotEmpty) {
        _selectedYear = data.years.first;
      }

      _yearsController.add(data.years);
      _scholarshipsController.add(data.scholarships);
    } catch (e) {
      uiError = AppI18n.current.errorUnexpected;
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  Future<void> onYearSelected(int year) async {
    _selectedYear = year;
    isLoading = LoadingData(isLoading: true);

    try {
      final scholarships = await loadYearScholarships.load(year);
      _scholarshipsController.add(scholarships);
    } catch (e) {
      uiError = AppI18n.current.errorUnexpected;
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  void dispose() {
    _yearsController.close();
    _scholarshipsController.close();
  }
}
