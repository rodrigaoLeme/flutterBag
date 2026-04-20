class Entity {
  final String obfuscatedEmail;

  const Entity({required this.obfuscatedEmail});

  factory Entity.empty() => const Entity(obfuscatedEmail: '');
}
