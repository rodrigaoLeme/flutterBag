import '../../../app/core/constants/course_level.dart';
import '../../../app/core/constants/process_type.dart';
import '../../../domain/entities/result_documents_entity.dart';
import '../../../ui/helpers/extensions/extensions.dart';

class ResultDocumentsViewModel {
  final List<ResultStudentViewModel>? students;

  ResultDocumentsViewModel({
    required this.students,
  });
}

extension ResultDocumentsViewModelExtensions on ResultDocumentsEntity {
  ResultDocumentsViewModel toViewModel({
    required String registerStart,
    required String registerEnd,
    required int? schoolRegistrationBusinessDaysLimit,
    required String resultRelease,
    required int year,
    required ProcessType tipoProcesso,
  }) =>
      ResultDocumentsViewModel(
        students: students
            ?.map(
              (student) => student.toViewModel(
                registerEnd: registerEnd,
                registerStart: registerStart,
                schoolRegistrationBusinessDaysLimit:
                    schoolRegistrationBusinessDaysLimit,
                resultRelease: resultRelease,
                year: year,
                tipoProcesso: tipoProcesso,
              ),
            )
            .toList(),
      );
}

class ResultStudentViewModel {
  final String? id;
  final FamilyMemberViewModel? familyMember;
  final ScholarshipSchoolViewModel? school;
  final AcademicCourseViewModel? academicCourse;
  final ApprovedGrantViewModel? approvedGrant;
  final CurrentGrantViewModel? currentGrant;
  final bool? studentRegistered;
  final int? attendanceStatus;
  final String? enrollmentId;
  final String? enrollment;
  final String? studentPhoto;
  final String registerStart;
  final String registerEnd;
  final int? schoolRegistrationBusinessDaysLimit;
  final String resultRelease;
  final int year;
  final ProcessType tipoProcesso;

  ResultStudentViewModel({
    required this.id,
    this.familyMember,
    this.school,
    this.academicCourse,
    this.approvedGrant,
    required this.studentRegistered,
    required this.attendanceStatus,
    this.enrollmentId,
    required this.currentGrant,
    required this.enrollment,
    required this.studentPhoto,
    required this.registerStart,
    required this.registerEnd,
    required this.schoolRegistrationBusinessDaysLimit,
    required this.resultRelease,
    required this.year,
    required this.tipoProcesso,
  });

  String get registerStartFormatted => registerStart.formatDate;
  String get registerEndFormatted => registerEnd.formatDate;

  String? get limitDateFormatted {
    if (schoolRegistrationBusinessDaysLimit == null || resultRelease.isEmpty) {
      return null;
    }

    final DateTime? baseDate = DateTime.tryParse(resultRelease);
    if (baseDate == null) return null;

    final DateTime limitDate = _addBusinessDays(
      baseDate,
      schoolRegistrationBusinessDaysLimit!,
    );

    return '${limitDate.day.toString().padLeft(2, '0')}/${limitDate.month.toString().padLeft(2, '0')}/${limitDate.year}';
  }

  DateTime _addBusinessDays(DateTime startDate, int businessDaysToAdd) {
    int addedDays = 0;
    DateTime currentDate = startDate;

    while (addedDays < businessDaysToAdd) {
      currentDate = currentDate.add(const Duration(days: 1));
      if (currentDate.weekday != DateTime.saturday &&
          currentDate.weekday != DateTime.sunday) {
        addedDays++;
      }
    }
    return currentDate;
  }
}

extension ProcessResultStudentViewModelExtensions on ResultStudentEntity {
  ResultStudentViewModel toViewModel({
    required String registerStart,
    required String registerEnd,
    required int? schoolRegistrationBusinessDaysLimit,
    required String resultRelease,
    required int year,
    required ProcessType tipoProcesso,
  }) =>
      ResultStudentViewModel(
          id: id,
          familyMember: familyMember?.toViewModel(),
          school: school?.toViewModel(),
          academicCourse: academicCourse?.toViewModel(),
          approvedGrant: approvedGrant?.toViewModel(),
          currentGrant: currentGrant?.toViewModel(),
          studentRegistered: studentRegistered,
          attendanceStatus: attendanceStatus,
          enrollmentId: enrollmentId,
          enrollment: enrollment,
          studentPhoto: studentPhoto,
          registerStart: registerStart,
          registerEnd: registerEnd,
          schoolRegistrationBusinessDaysLimit:
              schoolRegistrationBusinessDaysLimit,
          resultRelease: resultRelease,
          year: year,
          tipoProcesso: tipoProcesso);
}

class FamilyMemberViewModel {
  final String? name;

  FamilyMemberViewModel({
    required this.name,
  });
}

extension FamilyMemberViewModelExtensions on FamilyMemberEntity {
  FamilyMemberViewModel toViewModel() => FamilyMemberViewModel(
        name: name,
      );
}

class ScholarshipSchoolViewModel {
  final String? name;

  ScholarshipSchoolViewModel({
    required this.name,
  });
}

extension ScholarshipSchoolViewModelExtensions on ScholarshipSchoolEntity {
  ScholarshipSchoolViewModel toViewModel() => ScholarshipSchoolViewModel(
        name: name,
      );
}

class AcademicCourseViewModel {
  final CourseViewModel? course;
  final String? name;

  AcademicCourseViewModel({
    required this.name,
    required this.course,
  });
}

extension AcademicCourseViewModelExtensions on AcademicCourseEntity {
  AcademicCourseViewModel toViewModel() => AcademicCourseViewModel(
        name: name,
        course: course?.toViewModel(),
      );
}

class CourseViewModel {
  final String? id;
  final String? name;
  final int? courseLevel;

  CourseViewModel({
    this.id,
    this.name,
    this.courseLevel,
  });

  String? get courseLevelLabel => CourseLevel.getLabelFromCode(courseLevel);
}

extension CourseViewModelExtensions on CourseEntity {
  CourseViewModel toViewModel() => CourseViewModel(
        id: id,
        name: name,
        courseLevel: courseLevel,
      );
}

class ApprovedGrantViewModel {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  ApprovedGrantViewModel({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });
}

extension ApprovedGrantViewModelExtensions on ApprovedGrantEntity {
  ApprovedGrantViewModel toViewModel() => ApprovedGrantViewModel(
        approved: approved,
        approvedDateOnUtc: approvedDateOnUtc,
        createdOnUtc: createdOnUtc,
        grantedPercentage: grantedPercentage,
        observation: observation,
      );
}

class CurrentGrantViewModel {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? observation;

  CurrentGrantViewModel({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.createdOnUtc,
    required this.grantedPercentage,
    this.observation,
  });
}

extension CurrentGrantViewModelExtensions on CurrentGrantEntity {
  CurrentGrantViewModel toViewModel() => CurrentGrantViewModel(
        approved: approved,
        approvedDateOnUtc: approvedDateOnUtc,
        createdOnUtc: createdOnUtc,
        grantedPercentage: grantedPercentage,
        observation: observation,
      );
}
