import 'announcement_enums.dart';

class SchoolEntity {
  final String id;
  final String? name;
  final String? city;
  final String? state;
  final EducationLevel educationLevel;

  const SchoolEntity({
    required this.id,
    this.name,
    this.city,
    this.state,
    required this.educationLevel,
  });

  String get cityState => '$city - $state';
  String get displayName => name ?? id;
}
