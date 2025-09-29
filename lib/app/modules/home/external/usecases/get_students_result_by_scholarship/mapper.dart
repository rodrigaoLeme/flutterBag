import '../../../domain/usecases/get_students_result_by_scholarship/entity.dart';
import '../../../domain/usecases/get_students_result_by_scholarship/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic results) {
    if (results == null || results is! List) {
      throw const MapperException(
          message:
              'Não foi possível receber o resultado do processo. Formato da resposta inesperado.');
    }

    final studentProcess = <StudentResult>[];

    for (final result in results) {
      if (!result.keys.contains('familyMember')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember não encontrado');
      }

      final familyMember = result['familyMember'];
      if (familyMember is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember é inesperado (${familyMember.runtimeType})');
      }
      if (familyMember.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember é vazio');
      }

      if (!familyMember.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember.name não encontrado');
      }

      final familyMemberName = familyMember['name'];

      if (familyMemberName is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember.name é inesperado (${familyMemberName.runtimeType})');
      }

      if (familyMemberName.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo familyMember.name é vazio');
      }

      if (!result.keys.contains('school')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo school não encontrado');
      }

      final school = result['school'];
      if (school is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo school é inesperado (${school.runtimeType})');
      }
      if (school.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo school é vazio');
      }

      if (!school.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo school.name não encontrado');
      }

      final schoolName = school['name'];

      if (schoolName is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo schoolName.name é inesperado (${schoolName.runtimeType})');
      }

      if (schoolName.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo schoolName.name é vazio');
      }

      if (!result.keys.contains('academicCourse')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourse não encontrado');
      }

      final academicCourse = result['academicCourse'];
      if (academicCourse is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourse é inesperado (${academicCourse.runtimeType})');
      }
      if (academicCourse.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo scacademicCoursehool é vazio');
      }

      if (!academicCourse.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourse.name não encontrado');
      }

      final academicCourseName = academicCourse['name'];

      if (academicCourseName is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourseName é inesperado (${academicCourseName.runtimeType})');
      }

      if (academicCourseName.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourseName é vazio');
      }

      if (!result.keys.contains('approvedGrant')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrant não encontrado');
      }

      final approvedGrant = result['approvedGrant'];
      if (approvedGrant is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrant é inesperado (${approvedGrant.runtimeType})');
      }
      if (approvedGrant.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrant é vazio');
      }

      if (!approvedGrant.keys.contains('approved')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourse.name não encontrado');
      }

      final approvedGrantApproved = approvedGrant['approved'];

      if (approvedGrantApproved is! bool) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrantApproved é inesperado');
      }

      if (!approvedGrant.keys.contains('grantedPercentage')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo academicCourse.name não encontrado');
      }

      final approvedGrantGrantedPercentage = approvedGrant['grantedPercentage'];

      if (approvedGrantGrantedPercentage.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrantGrantedPercentage é vazio');
      }

      if (!approvedGrant.keys.contains('observation')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o resultado do processo: Campo approvedGrant.observation não encontrado');
      }

      final approvedGrantObservation = approvedGrant['observation'];

      studentProcess.add(
        StudentResult(
            studentName: familyMemberName,
            schoolName: schoolName,
            courseName: academicCourseName,
            approved: approvedGrantApproved,
            grantedPercentage: approvedGrantGrantedPercentage,
            observation: approvedGrantObservation),
      );
    }
    return Entity(students: studentProcess);
  }

  const Mapper();
}
