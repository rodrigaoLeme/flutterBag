import 'dart:convert';

class LoggedUser {
  const LoggedUser({
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiryTimeOnUtc,
  });
  final String token;
  final String refreshToken;
  final String refreshTokenExpiryTimeOnUtc;

  factory LoggedUser.empty() => const LoggedUser(token: '', refreshToken: '', refreshTokenExpiryTimeOnUtc: '');

  factory LoggedUser.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final refreshToken = json['refreshToken'];
    final refreshTokenExpiryTimeOnUtc = json['refreshTokenExpiryTimeOnUtc'];
    return LoggedUser(token: token, refreshToken: refreshToken, refreshTokenExpiryTimeOnUtc: refreshTokenExpiryTimeOnUtc);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpiryTimeOnUtc'] = refreshTokenExpiryTimeOnUtc;
    return data;
  }

  String toEncode() => jsonEncode(toJson());

  factory LoggedUser.fromEncode(String source) => LoggedUser.fromJson(jsonDecode(source));
}
