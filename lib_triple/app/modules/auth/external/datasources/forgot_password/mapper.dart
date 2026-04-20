import '../../../domain/usecases/forgot_password/entity.dart';
import '../../../domain/usecases/forgot_password/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic data) {
    if (data is! Map) {
      throw const MapperException(message: 'Não foi possível receber o e-mail de envio. Formato da resposta inesperado.');
    }
    if (data.isEmpty) {
      throw const MapperException(message: 'Não foi possível receber o e-mail de envio. Resultado vazio.');
    }
    if (!data.containsKey('email')) {
      throw const MapperException(message: 'Não foi possível receber o e-mail de envio. Email não retornado');
    }

    final email = data['email'];

    if (email is! String) {
      throw const MapperException(message: 'Não foi possível receber o e-mail de envio. Email é de tipo inesperado.');
    }
    if (email.isEmpty) {
      throw const MapperException(message: 'Não foi possível receber o e-mail de envio. Email vazio.');
    }

    return Entity(obfuscatedEmail: email);
  }

  const Mapper();
}
