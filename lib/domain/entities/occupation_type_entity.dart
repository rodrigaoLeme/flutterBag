class OccupationTypeEntity {
  final String id;
  final String name;
  final int? minAge;
  final int? maxAge;

  const OccupationTypeEntity({
    required this.id,
    required this.name,
    this.minAge,
    this.maxAge,
  });

  bool isAvailableForAge(int age) {
    if (minAge != null && age < minAge!) return false;
    if (maxAge != null && age > maxAge!) return false;
    return true;
  }
}

// TODO: Substituir pela lista do endpoint quando ficar pronta
class OccupationTypePlaceholder {
  static const List<OccupationTypeEntity> all = [
    OccupationTypeEntity(id: 'clt', name: 'CLT', minAge: 16),
    OccupationTypeEntity(id: 'autonomo', name: 'Autônomo', minAge: 18),
    OccupationTypeEntity(id: 'empresario', name: 'Empresário', minAge: 18),
    OccupationTypeEntity(id: 'estudante', name: 'Estudante'),
    OccupationTypeEntity(
        id: 'menor_aprendiz', name: 'Menor Aprendiz', minAge: 14, maxAge: 22),
    OccupationTypeEntity(
        id: 'estagio_remunerado', name: 'Estágio Remunerado', minAge: 16),
    OccupationTypeEntity(
        id: 'estagio_nao_remunerado',
        name: 'Estágio não Remunerado',
        minAge: 16),
    OccupationTypeEntity(id: 'desempregado', name: 'Desempregado'),
    OccupationTypeEntity(id: 'do_lar', name: 'Do Lar'),
    OccupationTypeEntity(id: 'aposentado', name: 'Aposentado'),
    OccupationTypeEntity(id: 'nenhum', name: 'Nenhum'),
  ];

  static List<OccupationTypeEntity> forAge(int age) =>
      all.where((o) => o.isAvailableForAge(age)).toList();
}
