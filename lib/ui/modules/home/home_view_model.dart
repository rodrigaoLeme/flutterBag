import '../../../domain/entities/scholarship_entity.dart';

class HomeViewModel {
  final List<int> years;
  final int selectedYear;
  final List<ScholarshipEntity> scholarships;
  final bool isLoading;
  final String? errorMessage;

  const HomeViewModel({
    this.years = const [],
    this.selectedYear = 0,
    this.scholarships = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  const HomeViewModel.initial() : this();

  bool get hasScholarships => scholarships.isNotEmpty;
}
