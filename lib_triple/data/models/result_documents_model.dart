import '../../domain/entities/result_documents_entity.dart';
import '../http/http_error.dart';

class ResultDocumentsModel {
  final List<ResultStudentModel>? students;

  ResultDocumentsModel({
    required this.students,
  });

  factory ResultDocumentsModel.fromJson(List<dynamic> json) {
    return ResultDocumentsModel(
      students: json
          .map<ResultStudentModel>((json) => ResultStudentModel.fromJson(json))
          .toList(),
    );
  }

  factory ResultDocumentsModel.fromEntity(ResultDocumentsEntity entity) =>
      ResultDocumentsModel(
        students: entity.students
            ?.map((e) => ResultStudentModel.fromEntity(e))
            .toList(),
      );

  ResultDocumentsEntity toEntity() => ResultDocumentsEntity(
        students:
            students?.map<ResultStudentEntity>((e) => e.toEntity()).toList(),
      );

  Map toJson() => {
        'students': students?.map((e) => e.toJson()).toList(),
      };
}

class ResultStudentModel {
  final String? id;
  final FamilyMemberModel? familyMember;
  final ScholarshipSchoolModel? school;
  final AcademicCourseModel? academicCourse;
  final ApprovedGrantModel? approvedGrant;
  final CurrentGrantModel? currentGrant;
  final bool? studentRegistered;
  final int? attendanceStatus;
  final String? enrollmentId;
  final String? enrollment;
  final String? studentPhoto;

  ResultStudentModel({
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

  factory ResultStudentModel.fromJson(Map json) {
    if (!json.containsKey('id')) {
      throw HttpError.invalidData;
    }

    return ResultStudentModel(
      id: json['id'],
      familyMember: FamilyMemberModel.fromJson(json['familyMember']),
      school: ScholarshipSchoolModel.fromJson(json['school']),
      academicCourse: AcademicCourseModel.fromJson(json['academicCourse']),
      approvedGrant: json['approvedGrant'] != null
          ? ApprovedGrantModel.fromJson(json['approvedGrant'])
          : null,
      currentGrant: json['currentGrant'] != null
          ? CurrentGrantModel.fromJson(json['currentGrant'])
          : null,
      studentRegistered: json['studentRegistered'],
      attendanceStatus: json['attendanceStatus'],
      enrollmentId: json['enrollmentId'],
      enrollment: json['enrollment'],
      studentPhoto: json['studentPhoto'],
    );
  }

  factory ResultStudentModel.fromEntity(ResultStudentEntity entity) =>
      ResultStudentModel(
        id: entity.id,
        familyMember: entity.familyMember != null
            ? FamilyMemberModel.fromEntity(entity.familyMember!)
            : null,
        school: entity.school != null
            ? ScholarshipSchoolModel.fromEntity(entity.school!)
            : null,
        academicCourse: entity.academicCourse != null
            ? AcademicCourseModel.fromEntity(entity.academicCourse!)
            : null,
        approvedGrant: entity.approvedGrant != null
            ? ApprovedGrantModel.fromEntity(entity.approvedGrant!)
            : null,
        currentGrant: entity.currentGrant != null
            ? CurrentGrantModel.fromEntity(entity.currentGrant!)
            : null,
        studentRegistered: entity.studentRegistered,
        attendanceStatus: entity.attendanceStatus,
        enrollmentId: entity.enrollmentId,
        enrollment: entity.enrollment,
        studentPhoto: entity.studentPhoto,
      );

  ResultStudentEntity toEntity() => ResultStudentEntity(
        id: id,
        familyMember: familyMember?.toEntity(),
        school: school?.toEntity(),
        academicCourse: academicCourse?.toEntity(),
        approvedGrant: approvedGrant?.toEntity(),
        currentGrant: currentGrant?.toEntity(),
        studentRegistered: studentRegistered,
        attendanceStatus: attendanceStatus,
        enrollmentId: enrollmentId,
        enrollment: enrollment,
        studentPhoto: studentPhoto,
      );

  Map toJson() => {
        'id': id,
        'familyMember': familyMember?.toJson(),
        'school': school?.toJson(),
        'academicCourse': academicCourse?.toJson(),
        'approvedGrant': approvedGrant?.toJson(),
        'studentRegistered': studentRegistered,
        'attendanceStatus': attendanceStatus,
        'enrollmentId': enrollmentId,
        'currentGrant': currentGrant,
        'enrollment': enrollment,
        'studentPhoto': studentPhoto,
      };
}

class FamilyMemberModel {
  final String? name;

  FamilyMemberModel({
    required this.name,
  });

  factory FamilyMemberModel.fromJson(Map json) {
    if (!json.containsKey('name')) {
      throw HttpError.invalidData;
    }

    return FamilyMemberModel(
      name: json['name'],
    );
  }

  factory FamilyMemberModel.fromEntity(FamilyMemberEntity entity) =>
      FamilyMemberModel(
        name: entity.name,
      );

  FamilyMemberEntity toEntity() => FamilyMemberEntity(
        name: name,
      );

  Map toJson() => {
        'name': name,
      };
}

class ScholarshipSchoolModel {
  final String? name;

  ScholarshipSchoolModel({
    required this.name,
  });

  factory ScholarshipSchoolModel.fromJson(Map json) {
    if (!json.containsKey('name')) {
      throw HttpError.invalidData;
    }

    return ScholarshipSchoolModel(
      name: json['name'],
    );
  }

  factory ScholarshipSchoolModel.fromEntity(ScholarshipSchoolEntity entity) =>
      ScholarshipSchoolModel(
        name: entity.name,
      );

  ScholarshipSchoolEntity toEntity() => ScholarshipSchoolEntity(
        name: name,
      );

  Map toJson() => {
        'name': name,
      };
}

class AcademicCourseModel {
  final CourseModel? course;
  final String? name;

  AcademicCourseModel({
    required this.name,
    required this.course,
  });

  factory AcademicCourseModel.fromJson(Map json) {
    if (!json.containsKey('name')) {
      throw HttpError.invalidData;
    }

    return AcademicCourseModel(
      course: CourseModel.fromJson(json['course']),
      name: json['name'],
    );
  }

  factory AcademicCourseModel.fromEntity(AcademicCourseEntity entity) =>
      AcademicCourseModel(
        course: entity.course != null
            ? CourseModel.fromEntity(entity.course!)
            : null,
        name: entity.name,
      );

  AcademicCourseEntity toEntity() => AcademicCourseEntity(
        course: course?.toEntity(),
        name: name,
      );

  Map toJson() => {
        'course': course,
        'name': name,
      };
}

class CourseModel {
  final String? id;
  final String? name;
  final int? courseLevel;

  CourseModel({
    this.id,
    this.name,
    this.courseLevel,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id')) {
      throw HttpError.invalidData;
    }

    return CourseModel(
      id: json['id'],
      name: json['name'],
      courseLevel: json['courseLevel'],
    );
  }

  factory CourseModel.fromEntity(CourseEntity entity) => CourseModel(
        id: entity.id,
        name: entity.name,
        courseLevel: entity.courseLevel,
      );

  CourseEntity toEntity() => CourseEntity(
        id: id,
        name: name,
        courseLevel: courseLevel,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'courseLevel': courseLevel,
      };
}

class ApprovedGrantModel {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  ApprovedGrantModel({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });

  factory ApprovedGrantModel.fromJson(Map json) {
    if (!json.containsKey('approved')) {
      throw HttpError.invalidData;
    }

    return ApprovedGrantModel(
      approved: json['approved'],
      approvedDateOnUtc: json['approvedDateOnUtc'],
      createdOnUtc: json['createdOnUtc'],
      grantedPercentage: json['grantedPercentage'],
      observation: json['observation'],
    );
  }

  factory ApprovedGrantModel.fromEntity(ApprovedGrantEntity entity) =>
      ApprovedGrantModel(
        approved: entity.approved,
        approvedDateOnUtc: entity.approvedDateOnUtc,
        createdOnUtc: entity.createdOnUtc,
        grantedPercentage: entity.grantedPercentage,
        observation: entity.observation,
      );

  ApprovedGrantEntity toEntity() => ApprovedGrantEntity(
        approved: approved,
        approvedDateOnUtc: approvedDateOnUtc,
        createdOnUtc: createdOnUtc,
        grantedPercentage: grantedPercentage,
        observation: observation,
      );

  Map toJson() => {
        'approved': approved,
        'approvedDateOnUtc': approvedDateOnUtc,
        'createdOnUtc': createdOnUtc,
        'grantedPercentage': grantedPercentage,
        'observation': observation,
      };
}

class CurrentGrantModel {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  CurrentGrantModel({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });

  factory CurrentGrantModel.fromJson(Map json) {
    if (!json.containsKey('approved')) {
      throw HttpError.invalidData;
    }

    return CurrentGrantModel(
      approved: json['approved'],
      approvedDateOnUtc: json['approvedDateOnUtc'],
      createdOnUtc: json['createdOnUtc'],
      grantedPercentage: json['grantedPercentage'],
      observation: json['observation'],
    );
  }

  factory CurrentGrantModel.fromEntity(CurrentGrantEntity entity) =>
      CurrentGrantModel(
        approved: entity.approved,
        approvedDateOnUtc: entity.approvedDateOnUtc,
        createdOnUtc: entity.createdOnUtc,
        grantedPercentage: entity.grantedPercentage,
        observation: entity.observation,
      );

  CurrentGrantEntity toEntity() => CurrentGrantEntity(
        approved: approved,
        approvedDateOnUtc: approvedDateOnUtc,
        createdOnUtc: createdOnUtc,
        grantedPercentage: grantedPercentage,
        observation: observation,
      );

  Map toJson() => {
        'approved': approved,
        'approvedDateOnUtc': approvedDateOnUtc,
        'createdOnUtc': createdOnUtc,
        'grantedPercentage': grantedPercentage,
        'observation': observation,
      };
}
