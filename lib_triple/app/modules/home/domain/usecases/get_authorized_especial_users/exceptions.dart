abstract class UsecaseException {
  final String? message;

  UsecaseException({this.message});

  @override
  String toString() => message != null ? message! : super.toString();
}

class UnknownUsecaseException extends UsecaseException {
  UnknownUsecaseException({super.message});
}
class MapperException extends UsecaseException {
  MapperException({super.message});
}

class ServerException extends UsecaseException {
  ServerException({String? message}) : super(message: message ?? 'Não foi possível estabelecer conexão');
}
