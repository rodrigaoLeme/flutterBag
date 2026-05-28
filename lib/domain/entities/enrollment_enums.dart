enum ResidenceAreaType {
  urban(1, 'Urbana'),
  rural(2, 'Rural'),
  vulnerability(3, 'Vulnerabilidade e risco');

  const ResidenceAreaType(this.value, this.label);
  final int value;
  final String label;

  static ResidenceAreaType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ResidenceAreaType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum ResidenceType {
  own(1, 'Próprio'),
  temporaryOrAssigned(2, 'Transitória/Cedida'),
  rented(3, 'Alugado'),
  financed(4, 'Financiado'),
  illegalOccupation(5, 'Ocupação irregular (invasão e/ou assentamento)'),
  institutionalOrCollective(6, 'Institucional/Coletiva'),
  other(7, 'Outro');

  const ResidenceType(this.value, this.label);
  final int value;
  final String label;

  static ResidenceType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ResidenceType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
