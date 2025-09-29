class Entity {
  final String sentFile;

  const Entity({required this.sentFile});

  factory Entity.empty() => const Entity(sentFile: '');
}
