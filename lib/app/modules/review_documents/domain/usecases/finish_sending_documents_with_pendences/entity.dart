class Entity {
  final bool response;

  const Entity({required this.response});

  factory Entity.empty() => const Entity(response: false);
}
