import 'dart:async';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/helpers/app_constants.dart';
import '../../../domain/usecases/notices/load_announcements.dart';
import '../../../domain/usecases/notices/load_schools.dart';
import '../../../infra/repositories/notices/remote_load_announcements_usecase.dart';
import '../../../infra/repositories/notices/remote_load_schools_usecase.dart';
import '../../../ui/modules/notices_terms/notices_terms_presenter.dart';
import '../../../ui/modules/notices_terms/notices_terms_view_model.dart';

class StreamNoticesTermsPresenter implements NoticesTermsPresenter {
  final LoadSchoolsUsecase loadSchoolsUsecase;
  final LoadAnnouncementsUsecase loadAnnouncementsUsecase;

  StreamNoticesTermsPresenter({
    required this.loadSchoolsUsecase,
    required this.loadAnnouncementsUsecase,
  });

  final _viewModelController =
      StreamController<NoticesTermsViewModel>.broadcast();
  final _noticesController = StreamController<List<NoticeEntity>>.broadcast();

  List<SchoolEntity> _cachedSchools = [];

  NoticesTermsViewModel _currentViewModel =
      const NoticesTermsViewModel.initial();

  @override
  Stream<NoticesTermsViewModel> get viewModelStream =>
      _viewModelController.stream;

  @override
  Stream<List<NoticeEntity>> get noticesStream => _noticesController.stream;

  @override
  void loadInitialData() {
    const initialYear = AppConstants.initialProcessYear;
    const initialMonthForEditalRelease =
        AppConstants.initialMonthForEditalRelease;

    final now = DateTime.now();
    final currentYear = now.year;

    final finalYear = now.month >= initialMonthForEditalRelease
        ? currentYear + 1
        : currentYear;

    final years = List.generate(
      finalYear - initialYear + 1,
      (i) => (finalYear - i).toString(),
    );

    _currentViewModel = _currentViewModel.copyWith(years: years);
    _emit(_currentViewModel);
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
      _cachedSchools =
          await loadSchoolsUsecase.load(LoadSchoolsParams(year: year));

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
        isLoadingSchools: false,
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
  Future<void> fetchNotices({
    required String year,
    required String city,
    required String schoolId,
    EducationLevel? educationLevel,
  }) async {
    try {
      final notices = await loadAnnouncementsUsecase.load(
        LoadAnnouncementsParams(
          year: year,
          city: city,
          schoolId: schoolId,
          educationLevel: educationLevel,
        ),
      );
      if (!_noticesController.isClosed) {
        _noticesController.add(notices);
      }
    } on LoadAnnouncementsException catch (_) {
      if (!_noticesController.isClosed) {
        _noticesController.add([]);
      }
    }
  }

  @override
  void clearNotices() => _noticesController.add([]);

  void _emit(NoticesTermsViewModel vm) {
    if (!_viewModelController.isClosed) {
      _viewModelController.add(vm);
    }
  }

  @override
  void dispose() {
    _viewModelController.close();
    _noticesController.close();
  }
}
