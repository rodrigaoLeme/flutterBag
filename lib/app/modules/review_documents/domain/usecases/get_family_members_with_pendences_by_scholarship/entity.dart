class Entity {
  final List<FamilyMemberWithPendences> familyMembers;

  const Entity({required this.familyMembers});

  factory Entity.empty() => const Entity(familyMembers: []);
}

class FamilyMemberWithPendences {
  final String id;
  final String name;

  const FamilyMemberWithPendences({
    required this.id,
    required this.name,
  });
}
