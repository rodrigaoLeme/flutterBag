// ignore_for_file: public_member_api_docs, sort_constructors_first
class Entity {
  final List<ProcessResultStudent> students;

  const Entity({required this.students});

  factory Entity.empty() => const Entity(students: []);
}

class ProcessResultStudent {
  final bool approved;
  final String name;
  final String schoolName;
  final String gradeName;

  ProcessResultStudent({
    required this.approved,
    required this.name,
    required this.schoolName,
    required this.gradeName,
  });
}
