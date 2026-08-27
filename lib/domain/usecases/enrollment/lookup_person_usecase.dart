import '../../entities/person_entity.dart';

abstract class LookupPersonUsecase {
  Future<PersonEntity?> lookup(String cpf);
}

class LookupPersonException implements Exception {
  final String message;
  const LookupPersonException(this.message);
}
