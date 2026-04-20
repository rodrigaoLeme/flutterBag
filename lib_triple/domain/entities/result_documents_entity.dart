import '../../app/core/constants/course_level.dart';

class ResultDocumentsEntity {
  final List<ResultStudentEntity>? students;

  const ResultDocumentsEntity({
    required this.students,
  });
}

class ResultStudentEntity {
  final String? id;
  final FamilyMemberEntity? familyMember;
  final ScholarshipSchoolEntity? school;
  final AcademicCourseEntity? academicCourse;
  final ApprovedGrantEntity? approvedGrant;
  final CurrentGrantEntity? currentGrant;
  final bool? studentRegistered;
  final int? attendanceStatus;
  final String? enrollmentId;
  final String? enrollment;
  final String? studentPhoto;

  ResultStudentEntity({
    required this.id,
    this.familyMember,
    this.school,
    this.academicCourse,
    this.approvedGrant,
    this.currentGrant,
    required this.studentRegistered,
    required this.attendanceStatus,
    this.enrollmentId,
    required this.enrollment,
    required this.studentPhoto,
  });
}

class FamilyMemberEntity {
  final String? name;

  FamilyMemberEntity({
    required this.name,
  });
}

class ScholarshipSchoolEntity {
  final String? name;

  ScholarshipSchoolEntity({
    required this.name,
  });
}

class AcademicCourseEntity {
  final CourseEntity? course;
  final String? name;

  AcademicCourseEntity({
    required this.name,
    required this.course,
  });
}

class CourseEntity {
  final String? id;
  final String? name;
  final int? courseLevel;

  CourseEntity({
    this.id,
    this.name,
    this.courseLevel,
  });

  String? get courseLevelLabel => CourseLevel.getLabelFromCode(courseLevel);
  CourseLevel? get courseLevelEnum => CourseLevel.fromCode(courseLevel);
}

class ApprovedGrantEntity {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  ApprovedGrantEntity({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });
}

class CurrentGrantEntity {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  CurrentGrantEntity({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });
}
