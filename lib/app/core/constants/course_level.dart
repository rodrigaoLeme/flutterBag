enum CourseLevel {
  educacaoInfantil(1, 'Educação Infantil'),
  ensinoFundamentalI(2, 'Ensino Fundamental I'),
  ensinoFundamentalII(3, 'Ensino Fundamental II'),
  ensinoMedio(4, 'Ensino Médio'),
  ensinoSuperiorGraduacao(5, 'Ensino Superior Graduação'),
  ensinoSuperiorLicenciatura(6, 'Ensino Superior Licenciatura'),
  ensinoSuperiorTecnologo(7, 'Ensino Superior Tecnólogo');

  final int code;
  final String label;

  const CourseLevel(this.code, this.label);

  static CourseLevel? fromCode(int? code) {
    if (code == null) return null;
    try {
      return CourseLevel.values.firstWhere((level) => level.code == code);
    } catch (e) {
      return null;
    }
  }

  static String? getLabelFromCode(int? code) {
    return fromCode(code)?.label;
  }
}
