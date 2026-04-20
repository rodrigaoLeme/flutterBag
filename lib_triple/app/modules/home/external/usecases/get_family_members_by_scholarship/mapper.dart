import '../../../domain/usecases/get_family_members_by_scholarship/entity.dart';
import '../../../domain/usecases/get_family_members_by_scholarship/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic results) {
    if (results == null || results is! List) {
      throw const MapperException(message: 'Não foi possível recuperar a bolsa. Formato da resposta inesperado.');
    }

    final familyMembers = <FamilyMember>[];

    for (final result in results) {
      if (!result.keys.contains('name')) {
        throw const MapperException(message: 'Não foi possível recuperar a bolsa: Campo name não encontrado');
      }
      final name = result['name'];

      if (name is! String) {
        throw MapperException(message: 'Não foi possível recuperar a bolsa: Campo name é inesperado (${name.runtimeType})');
      }
      if (name.isEmpty) {
        throw const MapperException(message: 'Não foi possível recuperar a bolsa: Campo name é vazio');
      }

      if (!result.keys.contains('id')) {
        throw const MapperException(message: 'Não foi possível recuperar a bolsa: Campo id não encontrado');
      }

      final id = result['id'];

      if (id is! String) {
        throw MapperException(message: 'Não foi possível recuperar a bolsa: Campo id é inesperado (${id.runtimeType})');
      }
      if (id.isEmpty) {
        throw const MapperException(message: 'Não foi possível recuperar a bolsa: Campo id é vazio');
      }

      familyMembers.add(FamilyMember(id: id, name: name));
    }

    return Entity(familyMembers: familyMembers);
  }

  const Mapper();
}
