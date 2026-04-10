// ignore_for_file: public_member_api_docs, sort_constructors_first
class Entity {
  final List<ProcessResultStudent> students;

  const Entity({required this.students});

  factory Entity.empty() => const Entity(students: []);
}

class ProcessResultStudent {
  final String? id;
  final FamilyMember? familyMember;
  final ScholarshipSchool? school;
  final AcademicCourse? academicCourse;
  final ApprovedGrant? approvedGrant;
  final bool? studentRegistered;
  final int? attendanceStatus;
  final String? enrollmentId;
  final bool? currentGrant;
  final String? enrollment;
  final String? studentPhoto;

  ProcessResultStudent({
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
  });
}

class FamilyMember {
  final String? id;
  final String? name;
  final String? personId;
  final String? person;
  final String? isResponsible;
  final String? scholarshipId;
  final String? declarationType;
  final int? maritalStatus;
  final String? declared;
  final int? kinshipType;
  final String? equityInterestId;
  final String? equityInterest;
  final String? inssAssistanceAmount;
  final bool? hasInssAssistance;
  final String? alimonyAmount;
  final bool? hasCompanies;
  final bool? ruralWorker;
  final bool? hasAlimony;
  final bool? hasWorkBooklet;
  final bool? hasCadUnico;
  final bool? hasChronicDisease;
  final bool? hasSpecialNeeds;
  final bool? isCandidate;
  final String? createdOnUtc;
  final bool? hasPrivatePension;
  final String? privatePensionAmount;
  final String? receivePension;
  final String? isRetired;
  final String? governmentBeneficiaryNIS;
  final String? chronicDiseaseName;
  final String? specialNeedsName;
  final String? specialNeeds;   

  FamilyMember({
    required this.id,
    required this.name,
    required this.personId,
    required this.maritalStatus,
    required this.kinshipType,
    required this.hasCompanies,
    required this.ruralWorker,
    required this.hasWorkBooklet,
    required this.hasCadUnico,
    required this.hasChronicDisease,
    required this.hasSpecialNeeds,
    required this.isCandidate,
    required this.createdOnUtc,
    required this.person,
    required this.isResponsible,
    required this.scholarshipId, 
    required this.declarationType, 
    required this.declared, 
    required this.equityInterestId, 
    required this.equityInterest, 
    required this.inssAssistanceAmount, 
    required this.hasInssAssistance, 
    required this.alimonyAmount, 
    required this.hasAlimony, 
    required this.hasPrivatePension, 
    required this.privatePensionAmount, 
    required this.receivePension, 
    required this.isRetired, 
    required this.governmentBeneficiaryNIS, 
    required this.chronicDiseaseName, 
    required this.specialNeedsName, 
    required this.specialNeeds,
  });
}

class ScholarshipSchool {
  final String? id;
  final String? name;
  final String? entityCNPJ;
  final int? entityCode;
  final String? alias;
  final Address? address;
  final bool? isEAD;
  final bool? disabled;
  final int? schoolType;
  final int? integrationType;
  final String? locationId;
  final String? parentEntityId;
  final String? parentEntity;
  final String? maintainingEntityId;
  final String? maintainingEntity;
  final String? schoolCourses;

  ScholarshipSchool( {
    required this.id,
    required this.name,
    required this.entityCNPJ,
    required this.entityCode,
    required this.alias,
    required this.address,
    required this.isEAD,
    required this.disabled,
    this.schoolType, 
    this.integrationType, 
    this.locationId, 
    this.parentEntityId, 
    this.parentEntity, 
    this.maintainingEntityId, 
    this.maintainingEntity, 
    this.schoolCourses,
  });
}

class Address {
  final String? id;
  final String? street;
  final String? number;
  final String? complement;
  final String? district;
  final String? city;
  final String? state;
  final String? zipCode;
  final bool? fromService;
  final Coordinate? coordinate;
  

  Address({
    required this.id,
    required this.street,
    required this.number,
    required this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.coordinate,
    required this.fromService,
  });
}

class Coordinate {
  final double? longitudeCode;
  final double? latitudeCode;

  Coordinate({
    required this.longitudeCode,
    required this.latitudeCode,
  });
}

class AcademicCourse {
  final String? id;
  final String? courseId;
  final String? course;
  final int? integrationType;
  final String? code;
  final String? name;

  AcademicCourse({
    required this.id,
    required this.courseId,
    required this.integrationType,
    required this.code,
    required this.name,
    required this.course,
  });
}

class ApprovedGrant {
  final bool? approved;
  final String? approvedDateOnUtc;
  final String? approverUser;
  final String? approverUserId;
  final String? committee; 
  final String? committeeId;
  final String? createdOnUtc;
  final int? grantedPercentage;
  final String? id;
  final String? observation;
  final String? rejectType;
  final String? rejectTypeId;
  final String? studentId;
  final bool? synced;
  final String? syncedDateOnUtc;
  final String? user;
  final String? userId;
  final String? academicCourseId;
  final String? academicCourse;
  final int? sequence;

  ApprovedGrant({
    required this.approved,
    required this.approvedDateOnUtc,
    required this.approverUserId,
    required this.committeeId,
    required this.createdOnUtc,
    required this.grantedPercentage,
    required this.id,
    required this.synced,
    required this.syncedDateOnUtc,
    required this.userId,
    required this.academicCourseId,
    required this.sequence,
    this.approverUser, 
    this.committee, 
    this.observation, 
    this.rejectType, 
    this.rejectTypeId, 
    this.studentId, 
    this.user, 
    this.academicCourse,
  });
}
