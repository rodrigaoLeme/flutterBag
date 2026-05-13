import 'announcement_enums.dart';

class SchoolEntity {
  final String id;
  final String name;
  final String city;
  final String state;
  final EducationLevel? educationLevel;

  const SchoolEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    this.educationLevel,
  });

  String get cityState => '$city - $state';
}
