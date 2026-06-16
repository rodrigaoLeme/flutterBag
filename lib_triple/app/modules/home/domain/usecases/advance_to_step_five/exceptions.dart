abstract class UsecaseException {
  final String? message;
  const UsecaseException({this.message});

  @override
  String toString() => message != null ? message! : super.toString();
}

class UnknownUsecaseException extends UsecaseException {
  const UnknownUsecaseException({String? message})
      : super(message: message ?? 'Não foi possível avançar para a etapa 5');
}

class ServerException extends UsecaseException {
  const ServerException({String? message})
      : super(message: message ?? 'Não foi possível estabelecer conexão');
}
