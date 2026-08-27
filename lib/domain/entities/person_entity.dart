class PersonEntity {
  final String id;
  final String? name;
  final String? cpf;
  final DateTime? birthDate;
  final int? gender;
  final int? maritalStatus;
  final String? rg;
  final String? rgIssuingAuthority;
  final bool? hasCin;
  final String? mobileNumber;
  final String? landlineNumber;
  final String? email;

  const PersonEntity({
    required this.id,
    this.name,
    this.cpf,
    this.birthDate,
    this.gender,
    this.maritalStatus,
    this.rg,
    this.rgIssuingAuthority,
    this.hasCin,
    this.mobileNumber,
    this.landlineNumber,
    this.email,
  });

  factory PersonEntity.fromJson(Map<String, dynamic> json) => PersonEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
        cpf: json['cpf'] as String?,
        birthDate: json['birthDate'] != null
            ? DateTime.tryParse(json['birthDate'] as String)
            : null,
        gender: json['gender'] as int?,
        maritalStatus: json['maritalStatus'] as int?,
        rg: json['rg'] as String?,
        rgIssuingAuthority: json['rgIssuingAuthority'] as String?,
        hasCin: json['hasCin'] as bool?,
        mobileNumber: json['mobileNumber'] as String?,
        landlineNumber: json['landlineNumber'] as String?,
        email: json['email'] as String?,
      );
}
