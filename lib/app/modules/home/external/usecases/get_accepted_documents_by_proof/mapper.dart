import '../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic results) {
    if (results == null || results is! List) {
      throw const MapperException(
          message:
              'Não foi possível recuperar os comprovantes. Formato da resposta inesperado.');
    }

    if (results.isEmpty) {
      throw const MapperException(
          message: 'Não foi possível recuperar os comprovantes aceitos');
    }

    final acceptedDocuments = <AcceptedDocument>[];

    for (final Map acceptedDocumentJson in results) {
      if (!acceptedDocumentJson.keys.contains('documentId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.documentId não encontrado');
      }
      final active = acceptedDocumentJson['active'];

      if (active is! bool) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.active é inesperado');
      }

      if (!active) {
        continue;
      }

      final id = acceptedDocumentJson['documentId'];

      if (id is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.documentId é inesperado (${id.runtimeType})');
      }

      if (id.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.documentId é vazio');
      }

      if (!acceptedDocumentJson.keys.contains('document')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.document não encontrado');
      }

      final document = acceptedDocumentJson['document'];

      if (document is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.document é inesperado (${document.runtimeType})');
      }

      if (document.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo acceptedDocumentJson.document é vazio');
      }
      if (!document.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo document.name não encontrado');
      }

      final name = document['name'];

      if (name is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo document.name é inesperado (${name.runtimeType})');
      }

      if (name.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo document.name é vazio');
      }

      if (!document.keys.contains('isDeclaration')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo document.isDeclaration não encontrado');
      }

      final isDeclaration = document['isDeclaration'];

      if (isDeclaration is! bool) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo document.isDeclaration é inesperado (${isDeclaration.runtimeType})');
      }

      if (!acceptedDocumentJson.keys.contains('proofItemConfigId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofItemConfigIdJson.entityProofItemId não encontrado');
      }

      final proofItemConfigId = acceptedDocumentJson['proofItemConfigId'];

      if (proofItemConfigId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofItemConfigIdJson.entityProofItemId é inesperado (${proofItemConfigId.runtimeType})');
      }

      if (proofItemConfigId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofItemConfigIdJson.entityProofItemId é vazio');
      }
      acceptedDocuments.add(AcceptedDocument(
          id: id,
          name: name,
          isDeclaration: isDeclaration,
          proofItemConfigId: proofItemConfigId));
    }

    return Entity(acceptedDocuments: acceptedDocuments);
  }

  const Mapper();
}
