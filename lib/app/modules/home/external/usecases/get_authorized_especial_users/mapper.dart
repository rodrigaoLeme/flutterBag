import '../../../domain/usecases/get_authorized_especial_users/entity.dart';

class Mapper {
  const Mapper();

  Entity fromMapToEntity(dynamic result) {
    if (result == null || result is! Map) {
      return Entity
          .empty(); // ou lance exceção, depende do comportamento desejado
    }

    final id = result['id'];
    if (id == null || id is! String) {
      return Entity.empty();
    }

    return Entity(id);
  }
}
