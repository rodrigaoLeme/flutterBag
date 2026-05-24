class NewScholarshipViewModel {
  final String lockedYear;
  final List<String> cities;
  final List<String> units;
  final bool isLoadingSchools;
  final String? schoolsError;

  const NewScholarshipViewModel({
    this.lockedYear = '',
    this.cities = const [],
    this.units = const [],
    this.isLoadingSchools = false,
    this.schoolsError,
  });

  const NewScholarshipViewModel.initial() : this();

  NewScholarshipViewModel copyWith({
    String? lockedYear,
    List<String>? cities,
    List<String>? units,
    bool? isLoadingSchools,
    String? schoolsError,
  }) =>
      NewScholarshipViewModel(
        lockedYear: lockedYear ?? this.lockedYear,
        cities: cities ?? this.cities,
        units: units ?? this.units,
        isLoadingSchools: isLoadingSchools ?? this.isLoadingSchools,
        schoolsError: schoolsError ?? this.schoolsError,
      );
}
