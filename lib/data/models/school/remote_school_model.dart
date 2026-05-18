import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/school_entity.dart';

class RemoteSchoolModel {
  final String id;
  final String? name;
  final String? city;
  final String? state;
  final int educationLevel;

  const RemoteSchoolModel({
    required this.id,
    this.name,
    this.city,
    this.state,
    required this.educationLevel,
  });

  factory RemoteSchoolModel.fromJson(Map<String, dynamic> json) =>
      RemoteSchoolModel(
        id: json['id'] as String,
        name: json['name'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        educationLevel: json['educationLevel'] as int,
      );

  SchoolEntity toEntity() => SchoolEntity(
        id: id,
        name: name ?? '',
        city: city ?? '',
        state: state ?? '',
        educationLevel: EducationLevel.fromValue(educationLevel),
      );
}
