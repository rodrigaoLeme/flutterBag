import '../../../domain/entities/school_entity.dart';

class NoticesTermsViewModel {
  final List<String> years;
  final List<String> cities;
  final List<SchoolEntity> units;
  final bool isLoadingSchools;
  final String? schoolsError;

  const NoticesTermsViewModel({
    this.years = const [],
    this.cities = const [],
    this.units = const [],
    this.isLoadingSchools = false,
    this.schoolsError,
  });

  const NoticesTermsViewModel.initial() : this();

  NoticesTermsViewModel copyWith({
    List<String>? years,
    List<String>? cities,
    List<SchoolEntity>? units,
    bool? isLoadingSchools,
    String? schoolsError,
  }) =>
      NoticesTermsViewModel(
        years: years ?? this.years,
        cities: cities ?? this.cities,
        units: units ?? this.units,
        isLoadingSchools: isLoadingSchools ?? this.isLoadingSchools,
        schoolsError: schoolsError,
      );
}
