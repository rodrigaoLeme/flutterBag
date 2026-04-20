import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/exceptions.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';

class Mapper {
  Map<String, dynamic> fromParamsToJson({required Params params}) {
    return params is FamilyMemberParams
        ? {'familyMemberId': params.familyMemberId}
        : {'isFamilyGroup': true};
  }

  Entity fromListToEntity(dynamic results) {
    if (results == null || results is! List) {
      throw const MapperException(
          message:
              'Não foi possível recuperar os comprovantes com pendências. Formato da resposta inesperado.');
    }

    final proofs = <ProofWithPendences>[];

    for (final result in results) {
      if (!result.keys.contains('entityProofConfig')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes com pendências: Campo entityProof não encontrado');
      }

      // proofId
      if (!result.keys.contains('id')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo id não encontrado');
      }

      final proofId = result['id'];

      if (proofId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo id é inesperado (${proofId.runtimeType})');
      }

      if (proofId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo id é vazio');
      }

      // scholarshipId
      if (!result.keys.contains('scholarshipId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo scholarshipId não encontrado');
      }

      final proofScholarshipId = result['scholarshipId'];

      if (proofScholarshipId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo scholarshipId é inesperado (${proofScholarshipId.runtimeType})');
      }

      if (proofScholarshipId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo scholarshipId é vazio');
      }

      // entityProofCategorieId
      // if (!result.keys.contains('entityProofCategorieId')) {
      //   throw const MapperException(
      //       message:
      //           'Não foi possível recuperar os comprovantes: Campo entityProofCategorieId não encontrado');
      // }

      // final proofEntityProofCategorieId = result['entityProofCategorieId'];

      // entityProofConfigId
      if (!result.keys.contains('entityProofConfigId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfigId não encontrado');
      }

      final proofEntityProofConfigId = result['entityProofConfigId'];

      if (proofEntityProofConfigId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfigId é inesperado (${proofEntityProofConfigId.runtimeType})');
      }

      if (proofEntityProofConfigId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfigId é vazio');
      }

      // entityProofConfig
      if (!result.keys.contains('entityProofConfig')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig não encontrado');
      }

      final proofEntityProofConfig = result['entityProofConfig'];

      if (proofEntityProofConfig is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig é inesperado (${proofEntityProofConfig.runtimeType})');
      }
      if (proofEntityProofConfig.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig é vazio');
      }

      // entityProofConfig - id
      if (!proofEntityProofConfig.keys.contains('id')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.id não encontrado');
      }

      final entityProofConfigId = proofEntityProofConfig['id'];

      if (entityProofConfigId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.id é inesperado (${entityProofConfigId.runtimeType})');
      }

      if (entityProofConfigId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.id é vazio');
      }

      // entityProofConfig - yearProofConfigId
      if (!proofEntityProofConfig.keys.contains('yearProofConfigId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.yearProofConfigId não encontrado');
      }

      final entityProofConfigYearProofConfigId =
          proofEntityProofConfig['yearProofConfigId'];

      if (entityProofConfigYearProofConfigId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.yearProofConfigId é inesperado (${entityProofConfigYearProofConfigId.runtimeType})');
      }

      if (entityProofConfigYearProofConfigId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.yearProofConfigId é vazio');
      }

      // entityProofConfig - proofId
      if (!proofEntityProofConfig.keys.contains('proofId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofId não encontrado');
      }

      final entityProofConfigProofId = proofEntityProofConfig['proofId'];

      if (entityProofConfigProofId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofId é inesperado (${entityProofConfigProofId.runtimeType})');
      }

      if (entityProofConfigProofId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofId é vazio');
      }

      // entityProofConfig - description

      if (!proofEntityProofConfig.keys.contains('description')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.description não encontrado');
      }

      final entityProofConfigDescription =
          proofEntityProofConfig['description'];

      // entityProofConfig - proof (EntityProof);
      if (!proofEntityProofConfig.keys.contains('proof')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof não encontrado');
      }

      final proofEntityProof = proofEntityProofConfig['proof'];

      if (proofEntityProof is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof é inesperado (${proofEntityProof.runtimeType})');
      }
      if (proofEntityProof.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof é vazio');
      }

      // entityProofConfig - proof - id
      if (!proofEntityProof.keys.contains('id')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofId não encontrado');
      }

      final entityProofId = proofEntityProof['id'];

      if (entityProofId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.id é inesperado (${entityProofId.runtimeType})');
      }

      if (entityProofId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.id é vazio');
      }

      // entityProofConfig - proof - name
      if (!proofEntityProof.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.name não encontrado');
      }

      final entityProofName = proofEntityProof['name'];

      if (entityProofName is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.name é inesperado (${entityProofName.runtimeType})');
      }

      if (entityProofName.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.name é vazio');
      }

      // entityProofConfig - proof - description
      if (!proofEntityProof.keys.contains('description')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.description não encontrado');
      }

      final entityProofDescription = proofEntityProof['description'];

      // entityProofConfig - proof - active
      if (!proofEntityProof.containsKey('active')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.active não encontrado');
      }

      final entityProofActive = proofEntityProof['active'];

      if (entityProofActive is! bool) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.name é inesperado');
      }

      // entityProofConfig - proof - proofCategoryId
      if (!proofEntityProof.keys.contains('proofCategoryId')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofCategoryId não encontrado');
      }

      final entityProofProofCategoryId = proofEntityProof['proofCategoryId'];

      if (entityProofProofCategoryId is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofCategoryId é inesperado (${entityProofProofCategoryId.runtimeType})');
      }

      if (entityProofProofCategoryId.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofCategoryId é vazio');
      }

      // entityProofConfig - proof (EntityProof) - ProofCategory
      if (!proofEntityProof.keys.contains('proofCategory')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof.proofCategory não encontrado');
      }

      final entityProofProofCategory = proofEntityProof['proofCategory'];

      if (entityProofProofCategory is! Map) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof.proofCategory é inesperado (${entityProofProofCategory.runtimeType})');
      }
      if (entityProofProofCategory.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proof.proofCategory é vazio');
      }

      // entityProofConfig - proof (EntityProof) - ProofCategory - id
      if (!entityProofProofCategory.keys.contains('id')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofCategoryId não encontrado');
      }

      final entityProofProofCategoryId2 = entityProofProofCategory['id'];

      if (entityProofProofCategoryId2 is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofProofCategory.id é inesperado (${entityProofProofCategoryId2.runtimeType})');
      }

      if (entityProofProofCategoryId2.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofProofCategory.id é vazio');
      }

      // entityProofConfig - proof (EntityProof) - ProofCategory - name
      if (!entityProofProofCategory.keys.contains('name')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo proofEntityProof.proofCategoryId não encontrado');
      }

      final entityProofProofCategoryName = entityProofProofCategory['name'];

      if (entityProofProofCategoryName is! String) {
        throw MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofProofCategory.name é inesperado (${entityProofProofCategoryName.runtimeType})');
      }

      if (entityProofProofCategoryName.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofProofCategory.name é vazio');
      }

      // entityProofConfig - proofItemConfigs
      if (!proofEntityProofConfig.keys.contains('proofItemConfigs')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs não encontrado');
      }
      final proofItemConfigs = proofEntityProofConfig['proofItemConfigs'];

      if (proofItemConfigs is! List) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes. entityProofConfig.proofItemConfigs tem formato inesperado.');
      }

      if (proofItemConfigs.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs é vazio');
      }

      final proofItemsConfigsObject = <ProofItemConfigsWithPendences>[];

      for (final proofItemConfigsResult in proofItemConfigs) {
        if (proofItemConfigsResult is! Map) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes. entityProofConfig.proofItemConfigs tem formato inesperado.');
        }

        // entityProofConfig - proofItemConfigs - id
        if (!proofItemConfigsResult.keys.contains('id')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs não encontrado');
        }

        final proofItemConfigsId = proofItemConfigsResult['id'];

        if (proofItemConfigsId is! String) {
          throw MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs é inesperado (${proofItemConfigsId.runtimeType})');
        }

        if (proofItemConfigsId.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs é vazio');
        }

        // entityProofConfig - proofItemConfigs - entityProofConfigId
        if (!proofItemConfigsResult.keys.contains('entityProofConfigId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.entityProofConfigId não encontrado');
        }

        final proofItemConfigsEntityProofConfigId =
            proofItemConfigsResult['entityProofConfigId'];

        if (proofItemConfigsEntityProofConfigId is! String) {
          throw MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.entityProofConfigId é inesperado (${proofItemConfigsEntityProofConfigId.runtimeType})');
        }

        if (proofItemConfigsEntityProofConfigId.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.entityProofConfigId é vazio');
        }

        // entityProofConfig - proofItemConfigs - description
        if (!proofItemConfigsResult.keys.contains('description')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.description não encontrado');
        }

        final proofItemConfigsEntityDescription =
            proofItemConfigsResult['description'];

        // entityProofConfig - proofItemConfigs - proofDocumentConfigs
        if (!proofItemConfigsResult.keys.contains('proofDocumentConfigs')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs não encontrado');
        }
        final proofDocumentConfigs =
            proofItemConfigsResult['proofDocumentConfigs'];

        if (proofDocumentConfigs is! List) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes. entityProofConfig.proofItemConfigs.proofDocumentConfigs tem formato inesperado.');
        }

        if (proofDocumentConfigs.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs é vazio');
        }

        final proofDocumentsConfigsObject =
            <ProofDocumentConfigsWithPendences>[];

        for (final proofDocumentConfigsResult in proofDocumentConfigs) {
          if (proofDocumentConfigsResult is! Map) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes. entityProofConfig.proofItemConfigs.proofDocumentConfigs tem formato inesperado.');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - id
          if (!proofDocumentConfigsResult.keys.contains('id')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.id não encontrado');
          }

          final proofDocumentConfigsId = proofDocumentConfigsResult['id'];

          if (proofDocumentConfigsId is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.id é inesperado (${proofDocumentConfigsId.runtimeType})');
          }

          if (proofDocumentConfigsId.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.id é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - proofItemConfigId
          if (!proofDocumentConfigsResult.keys.contains('proofItemConfigId')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.proofItemConfigId não encontrado');
          }

          final proofDocumentConfigsProofItemConfigId =
              proofDocumentConfigsResult['proofItemConfigId'];

          if (proofDocumentConfigsProofItemConfigId is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.proofItemConfigId é inesperado (${proofDocumentConfigsProofItemConfigId.runtimeType})');
          }

          if (proofDocumentConfigsProofItemConfigId.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.proofItemConfigId é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - documentId
          if (!proofDocumentConfigsResult.keys.contains('documentId')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.documentId não encontrado');
          }

          final proofDocumentConfigsDocumentId =
              proofDocumentConfigsResult['documentId'];

          if (proofDocumentConfigsDocumentId is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.documentId é inesperado (${proofDocumentConfigsDocumentId.runtimeType})');
          }

          if (proofDocumentConfigsDocumentId.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.documentId é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - active
          if (!proofDocumentConfigsResult.containsKey('active')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.active não encontrado');
          }

          final proofDocumentConfigsDocumentActive =
              proofDocumentConfigsResult['active'];

          if (proofDocumentConfigsDocumentActive is! bool) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.active é inesperado');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document
          if (!proofDocumentConfigsResult.keys.contains('document')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document não encontrado');
          }
          final proofDocumentConfigsDocument =
              proofDocumentConfigsResult['document'];

          if (proofDocumentConfigsDocument is! Map) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document é inesperado (${proofDocumentConfigsDocument.runtimeType})');
          }
          if (proofDocumentConfigsDocument.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - id
          if (!proofDocumentConfigsDocument.keys.contains('id')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.Id não encontrado');
          }

          final documentId = proofDocumentConfigsDocument['id'];

          if (documentId is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.Id é inesperado (${documentId.runtimeType})');
          }

          if (documentId.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.Id é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - name
          if (!proofDocumentConfigsDocument.keys.contains('name')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.name não encontrado');
          }

          final documentName = proofDocumentConfigsDocument['name'];

          if (documentName is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.name é inesperado (${documentName.runtimeType})');
          }

          if (documentName.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.name é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - nameDescription
          if (!proofDocumentConfigsDocument.keys.contains('nameDescription')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.nameDescription não encontrado');
          }

          final documentNameDescription =
              proofDocumentConfigsDocument['nameDescription'];

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - documentCategoryId
          if (!proofDocumentConfigsDocument.keys
              .contains('documentCategoryId')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.documentCategoryId não encontrado');
          }

          final documentDocumentCategoryId =
              proofDocumentConfigsDocument['documentCategoryId'];

          if (documentDocumentCategoryId is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.documentCategoryId é inesperado (${documentDocumentCategoryId.runtimeType})');
          }

          if (documentDocumentCategoryId.isEmpty) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.documentCategoryId é vazio');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - documentCategory
          if (!proofDocumentConfigsDocument.keys.contains('documentCategory')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.documentCategory não encontrado');
          }

          final documentDocumentCategory =
              proofDocumentConfigsDocument['documentCategory'];

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - isDeclaration
          if (!proofDocumentConfigsDocument.keys.contains('isDeclaration')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.isDeclaration não encontrado');
          }

          final documentIsDeclaration =
              proofDocumentConfigsDocument['isDeclaration'];

          if (documentIsDeclaration is! bool) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.isDeclaration é inesperado');
          }

          // entityProofConfig - proofItemConfigs - entityProofConfigId - proofDocumentConfigs - document - active
          if (!proofDocumentConfigsDocument.keys.contains('active')) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.active não encontrado');
          }

          final documentIsActive = proofDocumentConfigsDocument['active'];

          if (documentIsActive is! bool) {
            throw const MapperException(
                message:
                    'Não foi possível recuperar os comprovantes: Campo entityProofConfig.proofItemConfigs.proofDocumentConfigs.document.active é inesperado');
          }

          final proofDocumentConfigsObject = ProofDocumentConfigsWithPendences(
            id: proofDocumentConfigsId,
            proofItemConfigId: proofDocumentConfigsProofItemConfigId,
            documentId: proofDocumentConfigsDocumentId,
            document: DocumentWithPendences(
              id: documentId,
              name: documentName,
              nameDescription: documentNameDescription,
              documentCategoryId: documentDocumentCategoryId,
              documentCategory: documentDocumentCategory,
              isDeclaration: documentIsDeclaration,
              active: documentIsActive,
            ),
            active: proofDocumentConfigsDocumentActive,
          );

          proofDocumentsConfigsObject.add(proofDocumentConfigsObject);
        }

        final proofItemConfigsObject = ProofItemConfigsWithPendences(
          id: proofItemConfigsId,
          entityProofConfigId: proofItemConfigsEntityProofConfigId,
          description: proofItemConfigsEntityDescription,
          proofDocumentConfigs: proofDocumentsConfigsObject,
        );
        proofItemsConfigsObject.add(proofItemConfigsObject);
      }

      // entityProofConfig - ScholarshipProofDocument
      if (!result.keys.contains('scholarshipProofDocuments')) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocuments não encontrado');
      }
      final scholarshipProofDocuments = result['scholarshipProofDocuments'];

      if (scholarshipProofDocuments is! List) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes. ScholarshipProofDocuments tem formato inesperado.');
      }

      if (scholarshipProofDocuments.isEmpty) {
        throw const MapperException(
            message:
                'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocuments é vazio');
      }

      final scholarshipProofDocumentsObject =
          <ScholarshipProofDocumentWithPendences>[];
      //ProofItemConfigWithPendences proofItemConfigObject;

      for (final scholarshipProofDocumentsResult in scholarshipProofDocuments) {
        if (scholarshipProofDocumentsResult is! Map) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes. scholarshipProofDocumentsResult tem formato inesperado.');
        }

        // entityProofConfig - ScholarshipProofDocument - id
        if (!scholarshipProofDocumentsResult.keys.contains('id')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.Id não encontrado');
        }

        final scholarshipProofDocumentsId =
            scholarshipProofDocumentsResult['id'];

        if (scholarshipProofDocumentsId is! String) {
          throw MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.id é inesperado (${scholarshipProofDocumentsId.runtimeType})');
        }

        if (scholarshipProofDocumentsId.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.id é vazio');
        }

        // entityProofConfig - ScholarshipProofDocument - scholarshipProofId
        if (!scholarshipProofDocumentsResult.keys
            .contains('scholarshipProofId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.scholarshipProofId não encontrado');
        }

        final scholarshipProofId =
            scholarshipProofDocumentsResult['scholarshipProofId'];

        if (scholarshipProofId is! String) {
          throw MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.scholarshipProofId é inesperado (${scholarshipProofId.runtimeType})');
        }

        if (scholarshipProofId.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.scholarshipProofId é vazio');
        }

        // entityProofConfig - ScholarshipProofDocument - entityProofItemId

        final scholarshipProofDocumentReviewsObject =
            <ScholarshipProofDocumentReviews>[];

        if (!scholarshipProofDocumentsResult.keys
            .contains('entityProofItemId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.entityProofItemId não encontrado');
        }

        final scholarshipProofDocumentsEntityProofItemId =
            scholarshipProofDocumentsResult['entityProofItemId'];

        // entityProofConfig - ScholarshipProofDocument - proofItemConfigId
        if (!scholarshipProofDocumentsResult.keys
            .contains('proofItemConfigId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.proofItemConfigId não encontrado');
        }

        final scholarshipProofDocumentsProofItemConfigId =
            scholarshipProofDocumentsResult['proofItemConfigId'];

        if (scholarshipProofDocumentsProofItemConfigId is! String) {
          throw MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.proofItemConfigId é inesperado (${scholarshipProofDocumentsProofItemConfigId.runtimeType})');
        }

        if (scholarshipProofDocumentsProofItemConfigId.isEmpty) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.proofItemConfigId é vazio');
        }

        // entityProofConfig - ScholarshipProofDocument - documentId
        if (!scholarshipProofDocumentsResult.keys.contains('documentId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.documentId não encontrado');
        }

        final scholarshipProofDocumentsDocumentId =
            scholarshipProofDocumentsResult['documentId'];

        // entityProofConfig - ScholarshipProofDocument - fileId
        if (!scholarshipProofDocumentsResult.keys.contains('fileId')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.fileId não encontrado');
        }

        final scholarshipProofDocumentsFileId =
            scholarshipProofDocumentsResult['fileId'];

        // entityProofConfig - ScholarshipProofDocument - documentLocked
        if (!scholarshipProofDocumentsResult.keys.contains('documentLocked')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.documentLocked não encontrado');
        }

        final scholarshipProofDocumentsDocumentLocked =
            scholarshipProofDocumentsResult['documentLocked'];

        if (scholarshipProofDocumentsDocumentLocked is! bool) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.documentLocked é inesperado');
        }

        // entityProofConfig - ScholarshipProofDocument - proofItemConfig
        // if (!scholarshipProofDocumentsResult.keys.contains('proofItemConfig')) {
        //   throw const MapperException(
        //       message:
        //           'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.proofItemConfig não encontrado');
        // }

        // final proofItemConfig =
        //     scholarshipProofDocumentsResult['proofItemConfig'];

        // if (proofItemConfig is Map) {
        //   // entityProofConfig - ScholarshipProofDocument - proofItemConfig - id
        //   if (!proofItemConfig.keys.contains('id')) {
        //     throw const MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.id não encontrado');
        //   }

        //   final proofItemConfigId = proofItemConfig['id'];

        //   if (proofItemConfigId is! String) {
        //     throw MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.id é inesperado (${proofItemConfigId.runtimeType})');
        //   }

        //   if (proofItemConfigId.isEmpty) {
        //     throw const MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.id é vazio');
        //   }

        //   // entityProofConfig - ScholarshipProofDocument - proofItemConfig - entityProofConfigId
        //   if (!proofItemConfig.keys.contains('entityProofConfigId')) {
        //     throw const MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.entityProofConfigId não encontrado');
        //   }

        //   final proofItemConfigEntityProofConfigId =
        //       proofItemConfig['entityProofConfigId'];

        //   if (proofItemConfigEntityProofConfigId is! String) {
        //     throw MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.entityProofConfigId é inesperado (${proofItemConfigEntityProofConfigId.runtimeType})');
        //   }

        //   if (proofItemConfigEntityProofConfigId.isEmpty) {
        //     throw const MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.entityProofConfigId é vazio');
        //   }

        //   // entityProofConfig - ScholarshipProofDocument - proofItemConfig - description
        //   if (!proofItemConfig.keys.contains('description')) {
        //     throw const MapperException(
        //         message:
        //             'Não foi possível recuperar os comprovantes: Campo proofItemConfig.description não encontrado');
        //   }

        //   final proofItemConfigDescription = proofItemConfig['description'];

        //   proofItemConfigObject = ProofItemConfigWithPendences(
        //     id: proofItemConfigId,
        //     entityProofConfigId: proofItemConfigEntityProofConfigId,
        //     description: proofItemConfigDescription,
        //   );
        // }

        // entityProofConfig - ScholarshipProofDocument - scholarshipProofDocumentReviews
        if (!scholarshipProofDocumentsResult.keys
            .contains('scholarshipProofDocumentReviews')) {
          throw const MapperException(
              message:
                  'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentsResult.scholarshipProofDocumentReviews não encontrado');
        }

        final scholarshipProofDocumentReviews =
            scholarshipProofDocumentsResult['scholarshipProofDocumentReviews'];

        String observation = '';
        bool userHasResent = false;

        if (scholarshipProofDocumentReviews is List) {
          if (scholarshipProofDocumentReviews.isNotEmpty) {
            scholarshipProofDocumentReviews.sort(((a, b) {
              final firstReviewedAt = a['reviewedOnUtc'];
              final secondReviewedAt = b['reviewedOnUtc'];
              if (firstReviewedAt is! String) {
                throw MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: Campo reviewedOnUtc é inesperado (${firstReviewedAt.runtimeType})');
              }
              if (firstReviewedAt.isEmpty) {
                throw const MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: Campo reviewedOnUtc é vazio');
              }
              if (secondReviewedAt is! String) {
                throw MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: Campo reviewedOnUtc é inesperado (${secondReviewedAt.runtimeType})');
              }
              if (secondReviewedAt.isEmpty) {
                throw const MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: Campo reviewedOnUtc é vazio');
              }
              final firstReviewedAtDateTime =
                  DateTime.tryParse(firstReviewedAt);
              if (firstReviewedAtDateTime == null) {
                throw const MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: DateTime.tryParse do campo reviewedOnUtc é nulo');
              }
              final secondReviewedAtDateTime =
                  DateTime.tryParse(secondReviewedAt);
              if (secondReviewedAtDateTime == null) {
                throw const MapperException(
                    message:
                        'Não foi possível recuperar a bolsa: DateTime.tryParse do campo reviewedOnUtc é nulo');
              }

              return firstReviewedAtDateTime
                  .compareTo(secondReviewedAtDateTime);
            }));

            var scholarshipProofDocumentReview =
                scholarshipProofDocumentReviews.last;

            if (scholarshipProofDocumentReview is! Map) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes com pendências. Review com formato inesperado.');
            }

            if (!scholarshipProofDocumentReview.containsKey('observation')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes com pendências. ScholarshipProofDocumentReview não contém observation.');
            }

            final observationJson =
                scholarshipProofDocumentReview['observation'];

            if (observationJson != null && observationJson is! String) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes com pendências. ScholarshipProofDocumentReview.observation tem formato inesperado.');
            }

            observation = observationJson ?? '';

            if (!scholarshipProofDocumentReview.containsKey('resend')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes com pendências. ScholarshipProofDocumentReview não contém resend.');
            }

            final resend = scholarshipProofDocumentReview['resend'];

            if (resend != null && resend is! bool) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes com pendências. ScholarshipProofDocumentReview.resend tem formato inesperado.');
            }

            userHasResent = resend ?? false;

            // entityProofConfig - ScholarshipProofDocument - scholarshipProofDocumentReviews - id
            if (!scholarshipProofDocumentReview.containsKey('id')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.id não encontrado');
            }

            final scholarshipProofDocumentReviewsId =
                scholarshipProofDocumentReview['id'];

            if (scholarshipProofDocumentReviewsId is! String) {
              throw MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.id é inesperado (${scholarshipProofDocumentReviewsId.runtimeType})');
            }

            if (scholarshipProofDocumentReviewsId.isEmpty) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.id é vazio');
            }

            // entityProofConfig - ScholarshipProofDocument - scholarshipProofDocumentReviews - scholarshipProofDocumentId
            if (!scholarshipProofDocumentReview
                .containsKey('scholarshipProofDocumentId')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipProofDocumentId não encontrado');
            }

            final scholarshipProofDocumentId =
                scholarshipProofDocumentReview['scholarshipProofDocumentId'];

            if (scholarshipProofDocumentId is! String) {
              throw MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipProofDocumentId é inesperado (${scholarshipProofDocumentId.runtimeType})');
            }

            if (scholarshipProofDocumentId.isEmpty) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipProofDocumentId é vazio');
            }

            // entityProofConfig - ScholarshipProofDocument - scholarshipProofDocumentReviews - scholarshipReviewId
            if (!scholarshipProofDocumentReview
                .containsKey('scholarshipReviewId')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipReviewId não encontrado');
            }

            final scholarshipReviewId =
                scholarshipProofDocumentReview['scholarshipReviewId'];

            if (scholarshipReviewId is! String) {
              throw MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipReviewId é inesperado (${scholarshipReviewId.runtimeType})');
            }

            if (scholarshipReviewId.isEmpty) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.scholarshipReviewId é vazio');
            }

            // entityProofConfig - ScholarshipProofDocument - scholarshipProofDocumentReviews - newRequirement
            if (!scholarshipProofDocumentReview.containsKey('newRequirement')) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.newRequirement não encontrado');
            }

            final scholarshipNewRequirement =
                scholarshipProofDocumentReview['newRequirement'];

            if (scholarshipNewRequirement is! bool) {
              throw const MapperException(
                  message:
                      'Não foi possível recuperar os comprovantes: Campo scholarshipProofDocumentReviews.newRequirement é inesperado');
            }

            scholarshipProofDocumentReview = ScholarshipProofDocumentReviews(
              id: scholarshipProofDocumentReviewsId,
              scholarshipProofDocumentId: scholarshipProofDocumentId,
              scholarshipReviewId: scholarshipReviewId,
              observation: observation,
              resend: userHasResent,
              newRequirement: scholarshipNewRequirement,
            );

            scholarshipProofDocumentReviewsObject
                .add(scholarshipProofDocumentReview);
          }
        }

        final scholarshipProofDocumentObject =
            ScholarshipProofDocumentWithPendences(
          id: scholarshipProofDocumentsId,
          scholarshipProofId: scholarshipProofId,
          entityProofItemId: scholarshipProofDocumentsEntityProofItemId,
          proofItemConfigId: scholarshipProofDocumentsProofItemConfigId,
          scholarshipProofDocumentReviews:
              scholarshipProofDocumentReviewsObject,
          documentId: scholarshipProofDocumentsDocumentId,
          fileId: scholarshipProofDocumentsFileId,
          documentLocked: scholarshipProofDocumentsDocumentLocked,
          //proofItemConfigWithPendences: proofItemConfigObject ?? ProofItemConfigWithPendences.empty(),
        );

        scholarshipProofDocumentsObject.add(scholarshipProofDocumentObject);
      }

      // ************************************

      proofs.add(
        ProofWithPendences(
          id: proofId,
          scholarshipId: proofScholarshipId,
          //entityProofCategorieId: proofEntityProofCategorieId,
          entityProofConfigId: proofEntityProofConfigId,
          entityProofConfig: EntityProofConfigWithPendences(
            id: entityProofConfigId,
            yearProofConfigId: entityProofConfigYearProofConfigId,
            proofId: entityProofConfigProofId,
            entityProof: EntityProofWithPendences(
              id: entityProofId,
              name: entityProofName,
              description: entityProofDescription,
              active: entityProofActive,
              proofCategoryId: entityProofProofCategoryId,
              proofCategory: ProofCategoryWithPendences(
                id: entityProofProofCategoryId2,
                name: entityProofProofCategoryName,
              ),
            ),
            description: entityProofConfigDescription,
            proofItemConfigs: proofItemsConfigsObject,
          ),
          scholarshipProofDocuments: scholarshipProofDocumentsObject,
        ),
      );
    }

    return Entity(proofs: proofs);
  }

  const Mapper();
}
