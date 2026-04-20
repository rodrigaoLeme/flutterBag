import '../../entities/result_documents_entity.dart';

abstract class LoadResultDocuments {
  Future<ResultDocumentsEntity?> load(String scholarshipId);
}
