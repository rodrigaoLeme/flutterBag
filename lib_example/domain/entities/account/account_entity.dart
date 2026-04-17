class AccountEntity {
  final int id;
  final String name;
  final String email;

  AccountEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
