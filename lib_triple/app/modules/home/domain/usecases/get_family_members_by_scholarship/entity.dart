class Entity {
  final List<FamilyMember> familyMembers;

  const Entity({required this.familyMembers});

  factory Entity.empty() => const Entity(familyMembers: []);
}

class FamilyMember {
  final String id;
  final String name;

  const FamilyMember({
    required this.id,
    required this.name,
  });
}
