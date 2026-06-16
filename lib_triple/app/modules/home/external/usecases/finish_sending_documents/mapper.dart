import '../../../domain/usecases/finish_sending_documents/params.dart';

class Mapper {
  const Mapper();

  List<Map<String, String>> getDataFromParams(Params params) {
    return [
      {
        'ScholarshipId': '$params.scholarshipId',
        'AcceptTerm': '${params.acceptedTerms}',
        'Password': '$params.password',
      }
    ];
  }
}
