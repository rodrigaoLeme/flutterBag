abstract class UsecaseException {
  final String? message;

  const UsecaseException({this.message});

  @override
  String toString() => message != null ? message! : super.toString();
}

class UnknownUsecaseException extends UsecaseException {
  const UnknownUsecaseException({super.message});
}

class MapperException extends UsecaseException {
  const MapperException({super.message});
}

class ServerException extends UsecaseException {
  ServerException({String? message}) : super(message: message ?? 'Não foi possível estabelecer conexão');
}
