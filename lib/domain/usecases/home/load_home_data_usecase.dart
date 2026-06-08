import '../../entities/home_data_entity.dart';
import '../../entities/process_period_entity.dart';
import '../../entities/scholarship_entity.dart';
import '../../helpers/app_constants.dart';
import 'load_available_process_periods_usecase.dart';
import 'load_user_years_usecase.dart';
import 'load_year_scholarships_usecase.dart';

abstract class LoadHomeDataUsecase {
  Future<HomeDataEntity> load();
}

class LoadHomeDataUsecaseImpl implements LoadHomeDataUsecase {
  final LoadUserYearsUsecase loadUserYears;
  final LoadYearScholarshipsUsecase loadYearScholarships;
  final LoadAvailableProcessPeriodsUsecase loadAvailableProcessPeriods;

  const LoadHomeDataUsecaseImpl({
    required this.loadUserYears,
    required this.loadYearScholarships,
    required this.loadAvailableProcessPeriods,
  });

  @override
  Future<HomeDataEntity> load() async {
    final apiYears = await loadUserYears.load();
    final years = _buildYearList(apiYears);

    if (years.isEmpty) {
      return const HomeDataEntity(years: []);
    }

    final mostRecentYear = years.first;

    // Chamando os dois endpoints em paralelo
    final results = await Future.wait([
      loadYearScholarships.load(mostRecentYear),
      loadAvailableProcessPeriods.load(mostRecentYear),
    ]);

    return HomeDataEntity(
      years: years,
      scholarships: results[0] as List<ScholarshipEntity>,
      availablePeriods: results[1] as List<ProcessPeriodAvailableEntity>,
    );
  }

  List<int> _buildYearList(List<int> apiYears) {
    final now = DateTime.now();
    final currentYear = now.year;

    final yearSet = {...apiYears};

    if (!yearSet.contains(currentYear)) {
      yearSet.add(currentYear);
    }

    if (now.month >= AppConstants.initialMonthForEditalRelease &&
        !yearSet.contains(currentYear + 1)) {
      yearSet.add(currentYear + 1);
    }

    return yearSet.toList()..sort((a, b) => b.compareTo(a));
  }
}
