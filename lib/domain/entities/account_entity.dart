class AccountEntity {
  final String name;
  final String email;
  final String mobileNumber;
  final bool emailConfirmed;
  final String cpf;

  const AccountEntity(
      {required this.name,
      required this.email,
      required this.mobileNumber,
      required this.emailConfirmed,
      this.cpf = ''});

  AccountEntity copyWith({
    String? name,
    String? email,
    String? mobileNumber,
    bool? emailConfirmed,
  }) {
    return AccountEntity(
      name: name ?? this.email,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
        'emailConfirmed': emailConfirmed,
      };

  factory AccountEntity.fromJson(Map<String, dynamic> json) => AccountEntity(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        mobileNumber: json['mobileNumber'] as String? ?? '',
        emailConfirmed: json['emailConfirmed'] as bool? ?? false,
      );
}
