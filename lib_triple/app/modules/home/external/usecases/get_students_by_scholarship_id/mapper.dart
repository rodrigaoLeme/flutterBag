import '../../../domain/usecases/get_students_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_students_by_scholarship_id/exceptions.dart';

class Mapper {
  Entity fromResponseToEntity(dynamic response) {
    if (response == null) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado. Formato da resposta inesperado.');
    }
    late final Map mapResponse;
    try {
      mapResponse = response as Map;
    } catch (e) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado. Formato da resposta inesperado.');
    }
    if (mapResponse.isEmpty) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado. Formato da resposta inesperado.');
    }

    if (!mapResponse.containsKey('url')) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo url não encontrado');
    }

    final url = mapResponse['url'];

    if (url is! String) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo url tem formato inesperado');
    }

    if (url.isEmpty) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo url é vazio');
    }
    if (!mapResponse.containsKey('filename')) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo filename não encontrado');
    }

    final filename = mapResponse['filename'];

    if (filename is! String) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo filename tem formato inesperado');
    }

    if (filename.isEmpty) {
      throw const MapperException(message: 'Não foi possível recuperar o resultado: Campo filename é vazio');
    }

    return Entity.empty();
  }

  const Mapper();
}
