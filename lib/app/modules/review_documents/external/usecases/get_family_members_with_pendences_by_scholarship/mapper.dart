import '../../../domain/usecases/get_family_members_with_pendences_by_scholarship/entity.dart';
import '../../../domain/usecases/get_family_members_with_pendences_by_scholarship/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic results) {
    if (results == null || results is! List) {
      throw const MapperException(message: 'Não foi possível recuperar os familiares com pendências. Formato da resposta inesperado.');
    }

    final familyMembers = <FamilyMemberWithPendences>[];

    for (final result in results) {
      if (!result.keys.contains('name')) {
        throw const MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo name não encontrado');
      }
      final name = result['name'];

      if (name is! String) {
        throw MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo name é inesperado (${name.runtimeType})');
      }
      if (name.isEmpty) {
        throw const MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo name é vazio');
      }

      if (!result.keys.contains('id')) {
        throw const MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo id não encontrado');
      }

      final id = result['id'];

      if (id is! String) {
        throw MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo id é inesperado (${id.runtimeType})');
      }
      if (id.isEmpty) {
        throw const MapperException(message: 'Não foi possível recuperar os familiares com pendências: Campo id é vazio');
      }

      familyMembers.add(FamilyMemberWithPendences(id: id, name: name));
    }

    return Entity(familyMembers: familyMembers);
  }

  const Mapper();
}
