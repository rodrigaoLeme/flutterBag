import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization/localization.dart';

import '../../../entities/logged_user_v2.dart';
import '../../../services/storage/interface.dart';
import '../domain/refresh_token_params.dart';
import '../domain/refresh_token_usecase.dart';
import 'session_store_exceptions.dart';
import 'session_store_states.dart';

class SessionStore extends StreamStore<SessionStoreExceptions, SessionStoreStates> {
  final _userLoggedStorageKey = 'UserLogged';
  final Storage<String> _storage;
  final RefreshTokenUsecase _refreshTokenUsecase;

  SessionStore(this._storage, this._refreshTokenUsecase) : super(SessionStoreInitialState());

  Future<void> init() async {
    final result = await _checkStorageForStoredSessions();
    if (!_isThereAnyStoredSession(result)) {
      return log('Nenhum usuário armazenado');
    } else {
      log('Iniciando Session armazenada');
      final storedUser = _fromStorageFormatToLoggedUser(result!);
      _updateStoreWithANewLoggedUser(storedUser);
    }
  }

  Future<String?> _checkStorageForStoredSessions() async {
    return await _storage.get(_userLoggedStorageKey);
  }

  bool _isThereAnyStoredSession(String? result) {
    return !_isNullOrEmpty(result);
  }

  bool _isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  LoggedUser _fromStorageFormatToLoggedUser(String encodedJson) {
    return LoggedUser.fromEncode(encodedJson);
  }

  void _updateStoreWithANewLoggedUser(LoggedUser user) {
    update(SessionStoreUpdatedState(user));
  }

  Future<void> storeNewSession(LoggedUser user) async {
    await _storage.put(_userLoggedStorageKey, user.toEncode());
    _updateStoreWithANewLoggedUser(user);
  }

  Future<void> refreshToken() async {
    final accessToken = state.entity.token;
    final refreshToken = state.entity.refreshToken;
    if (_isNullOrEmpty(accessToken)) {
      setError(TokenRefreshException("refresh_token_store_empty_or_null_access_token".i18n()));
      return log(error!.message);
    }
    if (_isNullOrEmpty(refreshToken)) {
      setError(TokenRefreshException("refresh_token_store_empty_or_null_refresh_token".i18n()));
      return log(error!.message);
    }
    final result = await _refreshTokenUsecase(RefreshTokenParamsV2(accessToken, refreshToken));
    await result.fold(
      (exception) async {
        setError(TokenRefreshException(exception.message));
        log(exception.message);
      },
      (user) async {
        log("refresh_token_store_successful_refresh".i18n());
        await storeNewSession(user);
      },
    );
  }

  Future<void> logout() async {
    if (isLogged) {
      setLoading(true);
      await _clearSessionFromStorage();
      _resetStore();
      setLoading(false);
      log('Sessão finalizada');
    }
  }

  bool get isLogged => state is SessionStoreUpdatedState;

  Future<void> _clearSessionFromStorage() {
    return _storage.put(_userLoggedStorageKey, '');
  }

  void _resetStore() {
    update(SessionStoreInitialState());
  }

  Future<void> refreshTokenExpired() async {
    await logout();
    Modular.to.popUntil((p0) => false);
    Modular.to.pushNamed('/auth/');
  }

  Future<void> refreshTokenExceptionHandler() async {
    await logout();
    Modular.to.popUntil((p0) => false);
    Modular.to.pushNamed('/auth/');
  }
}
