import '../../../data/http/http_client.dart';
import '../../../domain/usecases/candidate/save_candidate_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveCandidateUsecase implements SaveCandidateUsecase {
  final HttpClient httpClient;

  const RemoteSaveCandidateUsecase({required this.httpClient});

  @override
  Future<String> save(SaveCandidateParams params) async {
    try {
      final hasId = params.id != null && params.id!.isNotEmpty;
      final body = <String, dynamic>{
        'familyMemberId': params.familyMemberId,
        'schoolId': params.schoolId,
        'academicCourseId': params.academicCourseId,
        'legalPersonType': params.legalPersonType,
        'educationLevel': params.educationLevel,
        'scholarshipType': params.scholarshipType,
        'completedGraduation': params.completedGraduation,
        'currentlyEnrolledInGraduation': params.currentlyEnrolledInGraduation,
        if (params.highSchoolScholarshipHolder != null)
          'highSchoolScholarshipHolder': params.highSchoolScholarshipHolder,
      };

      final response = await httpClient.request(
        url: hasId
            ? '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-4/candidates/${params.id}'
            : '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-4/candidates',
        method: hasId ? HttpMethod.put : HttpMethod.post,
        body: body,
      );

      return hasId ? params.id! : response['id'] as String;
    } on ApiException catch (e) {
      throw SaveCandidateException(_mapError(e.code, e.fullMessage));
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveCandidateException(AppI18n.current.errorNoInternet);
      }
      throw SaveCandidateException(AppI18n.current.errorUnexpected);
    }
  }

  String _mapError(String code, String fallback) {
    switch (code) {
      case 'FamilyMember.NotCandidate':
        return 'O membro não está marcado como candidato à bolsa. Verifique a Etapa 2.';
      case 'Student.AlreadyExists':
        return 'Este candidato já foi registrado para este membro familiar.';
      case 'Student.CandidateMinimumAgeViolation':
        return 'O candidato não possui a idade mínima exigida (4 anos completos até 31/03 do ano letivo).';
      case 'School.NotParticipating':
        return 'A unidade escolar não está habilitada para este processo.';
      case 'AcademicCourse.NotFoundForSchoolAndProcessPeriod':
        return 'O curso não está disponível para esta escola neste processo.';
      case 'Student.EducationLevelMismatch':
        return 'O nível de ensino não corresponde ao edital.';
      case 'Student.ScholarshipTypeMismatch':
        return 'O tipo de bolsa não corresponde ao edital.';
      case 'Student.InvalidLegalPersonType':
        return 'O tipo de responsável selecionado não é permitido para ensino básico.';
      case 'Student.CompletedGraduationRequired':
      case 'Student.CurrentlyEnrolledInGraduationRequired':
        return 'Campos de graduação são obrigatórios para ensino superior.';
      case 'Student.HighSchoolScholarshipHolderRequired':
        return 'Informe se o candidato foi bolsista no ensino médio.';
      case 'Student.InvalidProuniCandidate':
        return 'Candidato não encontrado na lista de pré-selecionados do PROUNI.';
      default:
        return fallback.isNotEmpty ? fallback : AppI18n.current.errorUnexpected;
    }
  }
}
