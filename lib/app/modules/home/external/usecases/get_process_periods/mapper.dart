import '../../../../../core/constants/process_type.dart';
import '../../../domain/usecases/get_process_periods/entity.dart';
import '../../../domain/usecases/get_process_periods/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic result) {
    if (result == null || result is! List) {
      throw const MapperException(
          message:
              'Não foi possível receber os períodos de processo. Formato da resposta inesperado.');
    }
    final processesList = <Process>[];
    for (final processJson in result) {
      final firstEntity = processJson;
      final idField = firstEntity['id'];
      if (idField == null) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo id é nulo');
      }
      if (idField is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo id é do tipo ${idField.runtimeType}');
      }
      if (idField.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo id é vazio');
      }
      final processTypeField = firstEntity['processType'];
      if (processTypeField == null) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo processType é nulo');
      }

      final digitalProcessType = firstEntity['digitalProcessType'];
      if (digitalProcessType is! int) {
        throw const MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo digitalProcessType tem tipo inesperado');
      }

      String? documentationUploadDeadline;
      if (digitalProcessType == 1) {
        documentationUploadDeadline =
            firstEntity['documentationUploadDeadLineOnUtc'];
        if (documentationUploadDeadline == null) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar o período de processo: Campo documentationUploadDeadLine é nulo');
        }
        if (documentationUploadDeadline.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar o período de processo: Campo documentationUploadDeadLine é vazio');
        }
      }

      String? documentationReturnUploadDeadline;
      if (digitalProcessType == 1) {
        documentationReturnUploadDeadline =
            firstEntity['documentationReturnUploadDeadLineOnUtc'];
        if (documentationReturnUploadDeadline == null) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar o período de processo: Campo documentationReturnUploadDeadline é nulo');
        }
        if (documentationReturnUploadDeadline.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar o período de processo: Campo documentationReturnUploadDeadline é vazio');
        }
      }

      late final ProcessType processType;
      try {
        processType = ProcessType.values.elementAt(processTypeField - 1);
      } catch (e) {
        throw MapperException(
            message:
                'Não foi possível recuperar o período de processo: Campo processType é inesperado ($processTypeField)');
      }

      if (!firstEntity.containsKey('registerStartOnUtc')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument não contém registerStart.');
      }

      final registerStart = firstEntity['registerStartOnUtc'];

      if (registerStart is! String) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.registerStart tem formato inesperado.');
      }
      if (registerStart.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.registerStart é vazio.');
      }
      if (!firstEntity.containsKey('registerEndOnUtc')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument não contém registerEnd.');
      }

      final registerEnd = firstEntity['registerEndOnUtc'];

      if (registerEnd is! String) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.registerEnd tem formato inesperado.');
      }
      if (registerEnd.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.registerEnd é vazio.');
      }
      if (!firstEntity.containsKey('resultReleaseOnUtc')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument não contém resultRelease.');
      }

      final resultRelease = firstEntity['resultReleaseOnUtc'];

      if (resultRelease is! String) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.resultRelease tem formato inesperado.');
      }
      if (resultRelease.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os processos. ScholarshipProofDocument.resultRelease é vazio.');
      }

      final process = Process(
        id: idField,
        processType: processType,
        documentationUploadDeadline: documentationUploadDeadline,
        documentationReturnUploadDeadLine: documentationReturnUploadDeadline,
        registerStart: registerStart,
        registerEnd: registerEnd,
        resultRelease: resultRelease,
      );
      processesList.add(process);
    }
    return Entity(processes: processesList);
  }

  const Mapper();
}
