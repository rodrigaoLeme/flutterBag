import '../../../flavors.dart';
import 'endpoints.dart';

class EndpointsV2Dev extends Endpoints {
  EndpointsV2Dev();

  final baseUri = 'http://ebolsa.educadventista.org/';
  @override
  final base = Flavor.apiBaseUrl;
  final loginWithId = '/api/v2/identity/token';
  final refreshToken = '/api/v2/identity/token/refresh';
  final processesYears =
      '/api/v2/scholarships/process-periods/year-processes/years';
  String processPeriods({required int year}) =>
      '/api/v2/year-processes/$year/process-periods';
  String authorizedEspecificUser(
          {required String periodId, required String userId}) =>
      '/api/v2/process-periods/$periodId/person-authorizations/$userId';
  String scholarship({required String periodId}) =>
      '/api/v2/process-periods/$periodId/scholarship';
  String familyMembers({required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/family-members';
  String proofs({required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/scholarship-proofs';
  String acceptedDocumentsByProof({required String entityProofItemId}) =>
      '/api/v2/proof-item-configs/$entityProofItemId/proof-document-configs';

  String sendProofDocument({required String scholarshipProofDocumentId}) =>
      '/api/v2/scholarship-proof-documents/$scholarshipProofDocumentId/upload';
  final forgotPassword = '/api/v2/identity/account/forgot-password';
  String file({required String fileId}) => '/api/v2/files/$fileId';
  String finishSendingDocuments({required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/step-six';

  //Revisão da documentação
  String familyMembersWithPendences({required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/family-members?hasPendences=true';
  String latestScholarshipReview({required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/scholarship-reviews/latest';
  String proofsWithPendences({required String scholarshipReviewId}) =>
      '/api/v2/scholarship-reviews/$scholarshipReviewId/scholarship-proofs';
  String finishSendingDocumentsWithPendences(
          {required String scholarshipReviewId}) =>
      '/api/v2/scholarship-reviews/$scholarshipReviewId';
  String sendProofDocumentWithPendences(
          {required String scholarshipReviewId,
          required String scholarshipProofDocumentId}) =>
      '/api/v2/scholarship-reviews/$scholarshipReviewId/scholarship-proof-documents/$scholarshipProofDocumentId/upload';
String processResultStudent(
          {required String scholarshipId}) =>
      '/api/v2/scholarships/$scholarshipId/students';
  //Resultado
  final students = '/api/v2/students';

  //Set deviceCode
  String setDeviceCode({required String nameIdentifier}) =>
      '/api/v2/users/$nameIdentifier';
}
