import 'process_period_entity.dart';
import 'scholarship_entity.dart';

class HomeDataEntity {
  final List<int> years;
  final List<ScholarshipEntity> scholarships;
  final List<ProcessPeriodAvailableEntity> availablePeriods;

  const HomeDataEntity({
    required this.years,
    this.scholarships = const [],
    this.availablePeriods = const [],
  });
}
