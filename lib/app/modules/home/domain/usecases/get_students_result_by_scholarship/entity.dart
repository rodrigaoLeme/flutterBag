class Entity {
  final List<StudentResult> students;

  const Entity({required this.students});

  factory Entity.empty() => const Entity(students: []);

  bool get isEmpty => students.isEmpty;
  bool get isNotEmpty => students.isNotEmpty;
}

/// Representa o resultado de um estudante individual
class StudentResult {
  final String studentName;
  final String schoolName;
  final String courseName;
  final bool approved;
  final int grantedPercentage;
  final String? observation;

  const StudentResult({
    required this.studentName,
    required this.schoolName,
    required this.courseName,
    required this.approved,
    required this.grantedPercentage,
    this.observation,
  });

  /// Retorna a mensagem de status
  String get statusMessage {
    if (approved) {
      return 'Deferido $grantedPercentage%';
    } else {
      return 'Indeferido';
    }
  }

  /// Verifica se tem observação
  bool get hasObservation => observation != null && observation!.isNotEmpty;
}
