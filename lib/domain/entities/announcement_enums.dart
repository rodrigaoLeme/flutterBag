enum ScholarshipType {
  ambos(0, 'CEBAS e PROUNI'),
  cebas(1, 'CEBAS'),
  prouni(2, 'PROUNI');

  const ScholarshipType(this.value, this.label);
  final int value;
  final String label;

  static ScholarshipType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ScholarshipType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum AnnouncementType {
  edital(1),
  additiveTerm(2);

  const AnnouncementType(this.value);
  final int value;

  static AnnouncementType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return AnnouncementType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum EducationLevel {
  basic(0, 'Ensino Básico'),
  higher(1, 'Ensino Superior');

  const EducationLevel(this.value, this.label);
  final int value;
  final String label;

  static EducationLevel? fromValue(int? value) {
    if (value == null) return null;
    try {
      return EducationLevel.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum ProcessType {
  renewal(1, 'Renovação'),
  newEnrollment(2, 'Nova Inscrição');

  const ProcessType(this.value, this.label);
  final int value;
  final String label;

  static ProcessType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ProcessType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
