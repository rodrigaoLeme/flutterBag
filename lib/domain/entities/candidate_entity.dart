import 'announcement_enums.dart';

class CandidateEntity {
  final String? id;
  final String? familyMemberId;
  final String? name;
  final String? cpf;
  final int? guardianRelationship;
  final String? schoolId;
  final String? schoolName;
  final String? gradeId;
  final String? gradeName;
  final int? educationLevel;
  final int? scholarshipType;
  final bool? highSchoolScholarshipHolder;

  const CandidateEntity({
    this.id,
    this.familyMemberId,
    this.name,
    this.cpf,
    this.guardianRelationship,
    this.schoolId,
    this.schoolName,
    this.gradeId,
    this.gradeName,
    this.educationLevel,
    this.scholarshipType,
    this.highSchoolScholarshipHolder,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyMemberId': familyMemberId,
        'name': name,
        'cpf': cpf,
        'guardianRelationship': guardianRelationship,
        'schoolId': schoolId,
        'schoolName': schoolName,
        'gradeId': gradeId,
        'gradeName': gradeName,
        'educationLevel': educationLevel,
        'scholarshipType': scholarshipType,
        'highSchoolScholarshipHolder': highSchoolScholarshipHolder,
      };

  Map<String, dynamic> toStudentRequestBody({int? educationLevel}) {
    final level = _effectiveEducationLevel(educationLevel);
    final type = _resolvedScholarshipType(level);
    final json = <String, dynamic>{
      'familyMemberId': familyMemberId,
      'schoolId': schoolId,
      'academicCourseId': gradeId,
      'legalPersonType': guardianRelationship,
      if (level != null) 'educationLevel': level,
      'scholarshipType': type,
      'completedGraduation': false,
      'currentlyEnrolledInGraduation': false,
      if (level == EducationLevel.higher.value)
        'highSchoolScholarshipHolder': highSchoolScholarshipHolder ?? false,
    };
    json.removeWhere((_, value) => value == null || value == '');
    return json;
  }

  int? _effectiveEducationLevel(int? formLevel) {
    final stored = educationLevel;
    if (stored == EducationLevel.higher.value ||
        stored == EducationLevel.basic.value) {
      return stored;
    }
    if (formLevel == EducationLevel.higher.value ||
        formLevel == EducationLevel.basic.value) {
      return formLevel;
    }
    return stored ?? formLevel;
  }

  int _resolvedScholarshipType(int? level) {
    if (level == EducationLevel.higher.value) {
      return ScholarshipType.prouni.value;
    }
    if (level == EducationLevel.basic.value) {
      return ScholarshipType.cebas.value;
    }
    if (scholarshipType == ScholarshipType.cebas.value ||
        scholarshipType == ScholarshipType.prouni.value) {
      return scholarshipType!;
    }
    return ScholarshipType.cebas.value;
  }

  Map<String, dynamic> toUiMap() => {
        'id': id,
        'familyMemberId': familyMemberId,
        'name': name,
        'cpf': cpf,
        'guardianRelationship': guardianRelationship,
        'schoolId': schoolId,
        'schoolName': schoolName,
        'gradeId': gradeId,
        'gradeName': gradeName,
        'educationLevel': educationLevel,
        'scholarshipType': scholarshipType,
        'highSchoolScholarshipHolder': highSchoolScholarshipHolder,
      };

  factory CandidateEntity.fromUiMap(Map<String, dynamic> map) =>
      CandidateEntity.fromJson(map);

  factory CandidateEntity.fromJson(Map<String, dynamic> json) {
    String? nestedId(dynamic value) {
      if (value is Map) return _asString(value['id']);
      return null;
    }

    String? nestedName(dynamic value) {
      if (value is! Map) return null;
      return (value['name'] ?? value['displayName']) as String?;
    }

    return CandidateEntity(
      id: _asString(json['id']),
      familyMemberId:
          _asString(json['familyMemberId']) ?? nestedId(json['familyMember']),
      name: json['name'] as String? ??
          json['familyMemberName'] as String? ??
          nestedName(json['familyMember']),
      cpf: json['cpf'] as String? ?? json['personCpf'] as String?,
      guardianRelationship: json['guardianRelationship'] as int? ??
          json['guardianRelationshipType'] as int? ??
          json['legalPersonType'] as int?,
      schoolId: _asString(json['schoolId']) ?? nestedId(json['school']),
      schoolName: json['schoolName'] as String? ?? nestedName(json['school']),
      gradeId: _asString(json['academicCourseId']) ??
          _asString(json['gradeId']) ??
          _asString(json['schoolGradeId']) ??
          nestedId(json['academicCourse']) ??
          nestedId(json['grade']) ??
          nestedId(json['schoolGrade']),
      gradeName: json['gradeName'] as String? ??
          json['academicCourseName'] as String? ??
          json['schoolGradeName'] as String? ??
          nestedName(json['academicCourse']) ??
          nestedName(json['grade']) ??
          nestedName(json['schoolGrade']),
      educationLevel: _parseInt(json['educationLevel']),
      scholarshipType: _parseInt(json['scholarshipType']),
      highSchoolScholarshipHolder:
          _parseBool(json['highSchoolScholarshipHolder']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final text = value.toLowerCase().trim();
      if (text == 'true' || text == '1') return true;
      if (text == 'false' || text == '0') return false;
    }
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return text;
  }
}
