abstract class AddAccount {
  Future<void> add(AddAccountParams params);
}

class AddAccountParams {
  final String name;
  final String email;
  final String phone;

  AddAccountParams({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
