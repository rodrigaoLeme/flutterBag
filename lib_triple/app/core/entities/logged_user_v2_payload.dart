import 'package:jwt_decoder/jwt_decoder.dart';

import 'logged_user_v2.dart';

class LoggedUserPayload {
  const LoggedUserPayload({
    required this.nameIdentifier,
    required this.emailAddress,
    required this.emailConfirmed,
    required this.dns,
    required this.name,
    required this.surname,
    required this.nbf,
    required this.exp,
  });
  final String nameIdentifier;
  final String emailAddress;
  final String emailConfirmed;
  final String dns;
  final String name;
  final String surname;
  final String nbf;
  final int exp;

  factory LoggedUserPayload.fromLoggedUser(LoggedUser user) {
    final token = user.token;
    if (token.isNotEmpty) {
      final json = JwtDecoder.decode(user.token);
      return LoggedUserPayload.fromJson(json);
    }
    return LoggedUserPayload.fromJson(<String, dynamic>{});
  }

  Map<String, dynamic> toMap() {
    return {
      'nameidentifier': nameIdentifier,
      'emailaddress': emailAddress,
      'emailconfirmed': emailConfirmed,
      'dns': dns,
      'name': name,
      'surname': surname,
      'nbf': nbf,
      'exp': exp,
    };
  }

  factory LoggedUserPayload.empty() {
    return const LoggedUserPayload(
      nameIdentifier: '',
      emailAddress: '',
      emailConfirmed: '',
      dns: '',
      name: '',
      surname: '',
      nbf: '',
      exp: -1,
    );
  }

  factory LoggedUserPayload.fromJson(Map<String, dynamic> map) {
    return LoggedUserPayload(
      nameIdentifier: map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? '',
      emailAddress: map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ?? '',
      emailConfirmed: map['emailconfirmed'] ?? '',
      dns: map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/dns'] ?? '',
      name: map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ?? '',
      surname: map['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname'] ?? '',
      nbf: map['nbf'] ?? '',
      exp: map['exp']?.toInt() ?? 0,
    );
  }
}
