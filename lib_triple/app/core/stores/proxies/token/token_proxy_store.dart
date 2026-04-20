import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../session/presenter/session_store.dart';

class TokenProxyStore {
  final SessionStore _sessionStore;

  String get token => _sessionStore.state.entity.token;

  Future<void> refreshToken() => _sessionStore.refreshToken();

  Either<TokenExpirationCheckException, bool> get isTokenExpired {
    try {
      final result = token.isEmpty ? false : JwtDecoder.isExpired(token);
      return Right(result);
    } catch (e) {
      log(e.toString());
      return const Left(TokenExpirationCheckException());
    }
  }

  bool get isRefreshTokenExpired {
    final refreshToken = _sessionStore.state.entity.refreshToken;
    if (refreshToken.isEmpty) {
      return false;
    }
    final refreshTokenExpiryTime = DateTime.parse(_sessionStore.state.entity.refreshTokenExpiryTimeOnUtc);
    final isRefreshTokenNotExpired = DateTime.now().isBefore(refreshTokenExpiryTime);
    return !isRefreshTokenNotExpired;
  }

  Future<void> refreshTokenExpiredHandler() {
    return _sessionStore.refreshTokenExpired();
  }

  Future<void> refreshTokenExceptionHandler() {
    return _sessionStore.refreshTokenExceptionHandler();
  }

  TokenProxyStore(this._sessionStore);
}

class TokenExpirationCheckException {
  const TokenExpirationCheckException();

  @override
  String toString() => 'Não foi possível verificar se o token está expirado';
}
