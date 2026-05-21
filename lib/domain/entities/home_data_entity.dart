import 'scholarship_entity.dart';

class HomeDataEntity {
  final List<int> years;
  final List<ScholarshipEntity> scholarships;

  const HomeDataEntity({
    required this.years,
    this.scholarships = const [],
  });
}
