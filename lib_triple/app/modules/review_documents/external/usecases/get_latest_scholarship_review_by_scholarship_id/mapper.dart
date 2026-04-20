import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/exceptions.dart';

class Mapper {
  Entity fromJsonToEntity(dynamic result) {
    if (result == null) {
      throw const MapperException(message: 'Não foi possível recuperar o id da revisão. Formato da resposta inesperado.');
    }

    Map resultMap;

    try {
      resultMap = result as Map;
    } catch (e) {
      throw const MapperException(message: 'Não foi possível recuperar o id da revisão. Formato da resposta é incompatível');
    }

    if (!resultMap.keys.contains('id')) {
      throw const MapperException(message: 'Não foi possível recuperar o id da revisão: Campo id não encontrado');
    }

    final id = resultMap['id'];

    if (id is! String) {
      throw MapperException(message: 'Não foi possível recuperar o id da revisão: Campo id é inesperado (${id.runtimeType})');
    }
    if (id.isEmpty) {
      throw const MapperException(message: 'Não foi possível recuperar o id da revisão: Campo id é vazio');
    }

    if (!resultMap.keys.contains('hasFamilyGroupPendences')) {
      throw const MapperException(message: 'Não foi possível recuperar o hasFamilyGroupPendences da revisão: Campo hasFamilyGroupPendences não encontrado');
    }

    final hasFamilyGroupPendences = resultMap['hasFamilyGroupPendences'];

    if (hasFamilyGroupPendences is! bool) {
      throw MapperException(message: 'Não foi possível recuperar o hasFamilyGroupPendences da revisão: Campo hasFamilyGroupPendences é inesperado (${hasFamilyGroupPendences.runtimeType})');
    }

    return Entity(id: id, hasFamilyGroupPendences: hasFamilyGroupPendences);
  }

  const Mapper();
}
