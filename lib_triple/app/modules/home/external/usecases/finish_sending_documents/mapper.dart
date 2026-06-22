import '../../../domain/usecases/finish_sending_documents/params.dart';

class Mapper {
  const Mapper();

  Map<String, dynamic> getDataFromParams(Params params) {
    return {
      'scholarshipId': params.scholarshipId,
      'acceptTerm': params.acceptedTerms,
      'password': params.password,
    };
  }
}
