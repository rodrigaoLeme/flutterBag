class Entity {
  final String id;
  final bool hasFamilyGroupPendences;

  const Entity({required this.id, required this.hasFamilyGroupPendences});

  factory Entity.empty() => const Entity(id: '', hasFamilyGroupPendences: false);
}
