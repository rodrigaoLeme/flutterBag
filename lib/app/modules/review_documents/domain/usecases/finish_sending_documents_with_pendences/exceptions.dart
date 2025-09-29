abstract class UsecaseException {
  final String? message;

  const UsecaseException({this.message});

  @override
  String toString() => message != null ? message! : super.toString();
}

class UnknownUsecaseException extends UsecaseException {
  const UnknownUsecaseException({String? message})
      : super(
            message:
                message ?? 'Não foi possível finalizar o envio de documentos');
}

class MapperException extends UsecaseException {
  const MapperException({super.message});
}

class ServerException extends UsecaseException {
  const ServerException({String? message})
      : super(message: message ?? 'Não foi possível estabelecer conexão');
}

class ResponseException extends UsecaseException {
  const ResponseException({String? message})
      : super(
            message:
                message ?? 'Não foi possível finalizar o envio de documentos');
}
