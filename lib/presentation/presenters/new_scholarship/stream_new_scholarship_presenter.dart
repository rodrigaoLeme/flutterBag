import 'dart:async';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/usecases/notices/load_available_announcements.dart';
import '../../../domain/usecases/notices/load_schools.dart';
import '../../../infra/repositories/notices/remote_load_available_announcements_usecase.dart';
import '../../../infra/repositories/notices/remote_load_schools_usecase.dart';
import '../../../ui/modules/new_scholarship/new_scholarship_presenter.dart';
import '../../../ui/modules/new_scholarship/new_scholarship_view_model.dart';

class StreamNewScholarshipPresenter implements NewScholarshipPresenter {
  final LoadSchoolsUsecase loadSchoolsUsecase;
  final LoadAvailableAnnouncementsUsecase loadAvailableAnnouncementsUsecase;

  StreamNewScholarshipPresenter({
    required this.loadSchoolsUsecase,
    required this.loadAvailableAnnouncementsUsecase,
  });

  final _viewModelController =
      StreamController<NewScholarshipViewModel>.broadcast();
  final _announcementsController =
      StreamController<List<AvailableAnnouncementEntity>>.broadcast();

  List<SchoolEntity> _cachedSchools = [];
  NewScholarshipViewModel _currentViewModel =
      const NewScholarshipViewModel.initial();

  @override
  Stream<NewScholarshipViewModel> get viewModelStream =>
      _viewModelController.stream;

  @override
  Stream<List<AvailableAnnouncementEntity>> get announcementsStream =>
      _announcementsController.stream;

  @override
  void loadInitialData(int lockedYear) {
    _currentViewModel = _currentViewModel.copyWith(
      lockedYear: lockedYear.toString(),
    );
    _emit(_currentViewModel);
    loadSchools(lockedYear.toString());
  }

  @override
  Future<void> loadSchools(String year) async {
    _currentViewModel = _currentViewModel.copyWith(
      isLoadingSchools: true,
      cities: [],
      units: [],
      schoolsError: null,
    );
    _emit(_currentViewModel);

    try {
      _cachedSchools = await loadSchoolsUsecase.load(
        LoadSchoolsParams(year: year),
      );

      final cities = _cachedSchools
          .where((s) => s.city != null && s.state != null)
          .map((s) => s.cityState)
          .toSet()
          .toList()
        ..sort();

      _currentViewModel = _currentViewModel.copyWith(
        isLoadingSchools: false,
        cities: cities,
        units: [],
      );
      _emit(_currentViewModel);
    } on LoadSchoolsException catch (e) {
      _cachedSchools = [];
      _currentViewModel = _currentViewModel.copyWith(
        schoolsError: e.message,
      );
      _emit(_currentViewModel);
    }
  }

  @override
  List<SchoolEntity> getUnitsForCity(String cityState) {
    return _cachedSchools.where((s) => s.cityState == cityState).toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
  }

  @override
  Future<void> fetchAnnouncements({
    required String year,
    required String city,
    required String schoolId,
    EducationLevel? educationLevel,
  }) async {
    try {
      final announcements = await loadAvailableAnnouncementsUsecase.load(
        LoadAvailableAnnouncementsParams(
          year: year,
          city: city,
          schoolId: schoolId,
          processType: ProcessType.newEnrollment, // Como é processo para novos
          educationLevel: educationLevel,
        ),
      );
      if (!_announcementsController.isClosed) {
        _announcementsController.add(announcements);
      }
    } on LoadAvailableAnnouncementsException catch (_) {
      if (!_announcementsController.isClosed) {
        _announcementsController.add([]);
      }
    }
  }

  @override
  void clearAnnouncements() {
    if (!_announcementsController.isClosed) {
      _announcementsController.add([]);
    }
  }

  void _emit(NewScholarshipViewModel vm) {
    if (!_viewModelController.isClosed) _viewModelController.add(vm);
  }

  @override
  void dispose() {
    _viewModelController.close();
    _announcementsController.close();
  }
}
