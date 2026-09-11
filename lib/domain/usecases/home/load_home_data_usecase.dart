import '../../entities/home_data_entity.dart';
import '../../helpers/app_constants.dart';
import 'load_user_years_usecase.dart';
import 'load_year_scholarships_usecase.dart';

abstract class LoadHomeDataUsecase {
  Future<HomeDataEntity> load();
}

class LoadHomeDataUsecaseImpl implements LoadHomeDataUsecase {
  final LoadUserYearsUsecase loadUserYears;
  final LoadYearScholarshipsUsecase loadYearScholarships;

  const LoadHomeDataUsecaseImpl({
    required this.loadUserYears,
    required this.loadYearScholarships,
  });

  @override
  Future<HomeDataEntity> load() async {
    final apiYears = await loadUserYears.load();
    final years = _buildYearList(apiYears);

    if (years.isEmpty) {
      return const HomeDataEntity(years: []);
    }

    final scholarships = await loadYearScholarships.load(years.first);

    return HomeDataEntity(
      years: years,
      scholarships: scholarships,
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
