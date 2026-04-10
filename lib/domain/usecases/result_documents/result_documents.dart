import '../../entities/result_documents_entity.dart';

abstract class ResultDocuments {
  Future<ResultDocumentsEntity> verify(ResultParms params);
}

class ResultParms {
  final String? scholarshipId;

  ResultParms({
    required this.scholarshipId,
  });

  Map toJson() => {
        'scholarshipId': scholarshipId,
      };
}
