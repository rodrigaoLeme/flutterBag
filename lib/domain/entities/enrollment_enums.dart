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
  commonLawMarriage(1, 'União Estável'),
  widower(2, 'Viúvo(a)'),
  separated(3, 'Separado(a) de fato'),
  single(4, 'Solteiro(a)'),
  married(5, 'Casado(a)'),
  divorced(6, 'Divorciado(a)');

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
  father(2, 'Pai'),
  spouse(3, 'Esposo(a)'),
  partner(4, 'Companheiro(a)'),
  mother(5, 'Mãe'),
  child(6, 'Filho(a)'),
  sibling(7, 'Irmão(ã)'),
  grandChild(8, 'Neto(a)'),
  grandParent(9, 'Avô(ó)'),
  auntOuUncle(10, 'Tio(a)'),
  niceOrNeohew(11, 'Sobrinho(a)'),
  greatGrandparent(12, 'Bisavô(ó)'),
  greatGrandchild(13, 'Bisneto(a)'),
  cousin(14, 'Primo(a)'),
  parentInLaw(15, 'Sogro(a)'),
  stepfather(16, 'Padrasto'),
  stepmother(17, 'Madrasta'),
  stepchild(18, 'Enteado(a)'),
  siblingInLaw(19, 'Cunhado(a)'),
  sonInLaw(20, 'Genro'),
  daughterInLaw(21, 'Nora'),
  grandAuntOrUncle(23, 'Tio(a)-avô(ó)'),
  grandNieceOrNephew(24, 'Sobrinho(a)-neto(a)'),
  coParentInLaw(25, 'Consogro(a)'),
  nieceOrNephewInLaw(26, 'Sobrinho(a)-afim'),
  auntOrUncleInLaw(27, 'Tio(a)-afim'),
  unrelated(99, 'Sem parentesco');

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

enum Gender {
  famale(1, 'Feminino'),
  male(2, 'Masculino');

  const Gender(this.value, this.label);
  final int value;
  final String label;

  static Gender? fromValue(int? value) {
    if (value == null) return null;
    try {
      return Gender.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum OccupationRule {
  hasIncome(10),
  hasFunction(20),
  hasDescription(30),
  childrenOnly(40),
  juniorTeenagerOnly(50),
  seniorTeenagerOnly(60),
  juniorAdultOnly(70),
  seniorAdultOnly(80),
  seniorAdultPwdOnly(90);

  const OccupationRule(this.value);
  final int value;

  static OccupationRule? fromValue(int value) {
    try {
      return OccupationRule.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
