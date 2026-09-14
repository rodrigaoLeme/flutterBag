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

enum GuardianRelationshipType {
  father(1, 'Sou pai'),
  mother(2, 'Sou mãe'),
  legalGuardian(3, 'Tenho guarda judicial');

  const GuardianRelationshipType(this.value, this.label);
  final int value;
  final String label;

  static GuardianRelationshipType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return GuardianRelationshipType.values
          .firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum MaritalStatus {
  uniaoEstavel(1, 'União Estável'),
  viuvo(2, 'Viúvo(a)'),
  separadoFato(3, 'Separado(a) de fato'),
  solteiro(4, 'Solteiro(a)'),
  casado(5, 'Casado(a)'),
  divorciado(6, 'Divorciado(a)');

  const MaritalStatus(this.value, this.label);
  final int value;
  final String label;

  static MaritalStatus? fromValue(int? value) {
    if (value == null) return null;
    try {
      return MaritalStatus.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum KinshipType {
  pai(2, 'Pai'),
  esposo(3, 'Esposo(a)'),
  companheiro(4, 'Companheiro(a)'),
  mae(5, 'Mãe'),
  filho(6, 'Filho(a)'),
  irmao(7, 'Irmão(ã)'),
  neto(8, 'Neto(a)'),
  avo(9, 'Avô(ó)'),
  tio(10, 'Tio(a)'),
  sobrinho(11, 'Sobrinho(a)'),
  bisavo(12, 'Bisavô(ó)'),
  bisneto(13, 'Bisneto(a)'),
  primo(14, 'Primo(a)'),
  sogro(15, 'Sogro(a)'),
  padrasto(16, 'Padrasto'),
  madrasta(17, 'Madrasta'),
  enteado(18, 'Enteado(a)'),
  cunhado(19, 'Cunhado(a)'),
  genro(20, 'Genro'),
  nora(21, 'Nora'),
  tioAvo(23, 'Tio(a)-avô(ó)'),
  sobrinhoNeto(24, 'Sobrinho(a)-neto(a)'),
  consogro(25, 'Consogro(a)'),
  sobrinhoAfim(26, 'Sobrinho(a)-afim'),
  tioAfim(27, 'Tio(a)-afim'),
  semParentesco(99, 'Sem parentesco');

  const KinshipType(this.value, this.label);
  final int value;
  final String label;

  static KinshipType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return KinshipType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
