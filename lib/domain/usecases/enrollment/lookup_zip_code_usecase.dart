class ZipCodeEntity {
  final String cep;
  final String? street;
  final String? neighborhood;
  final String? city;
  final String? state;

  const ZipCodeEntity({
    required this.cep,
    this.street,
    this.neighborhood,
    this.city,
    this.state,
  });
}

abstract class LookupZipCodeUsecase {
  Future<ZipCodeEntity> lookup(String cep);
}

class ZipCodeNotFoundException implements Exception {
  const ZipCodeNotFoundException();
}
