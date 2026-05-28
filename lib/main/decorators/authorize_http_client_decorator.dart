import '../../data/cache/cache.dart';
import '../../data/http/http_client.dart';
import '../../main/flavors.dart';
import '../../share/current_account.dart';
import '../../share/session_events.dart';
import '../../share/utils/jwt_decoder.dart';
import '../di/injection_container.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final SecureStorage secureStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.secureStorage,
    required this.decoratee,
  });

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var token = await secureStorage.fetch(key: StorageKeys.accessToken);

      if (token != null && JwtDecoder.isExpired(token)) {
        token = await _tryRefresh();
      }

      final authorizedHeaders = Map<String, dynamic>.from(headers ?? {});
      if (token != null) {
        authorizedHeaders['authorization'] = 'Bearer $token';
      }

      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
        queryParameters: queryParameters,
      );
    } on HttpError catch (error) {
      if (error == HttpError.unauthorized) {
        final newToken = await _tryRefresh();
        final authorizedHeaders = Map<String, dynamic>.from(headers ?? {});
        authorizedHeaders['authorization'] = 'Bearer $newToken';
        return await decoratee.request(
          url: url,
          method: method,
          body: body,
          headers: authorizedHeaders,
          queryParameters: queryParameters,
        );
      }
      rethrow;
    } on ApiException {
      rethrow;
    }
  }

  Future<String> _tryRefresh() async {
    var token = await secureStorage.fetch(key: StorageKeys.accessToken);
    final refreshToken = await secureStorage.fetch(
      key: StorageKeys.refreshToken,
    );
    if (refreshToken == null) {
      await _clearSessionOnly();
      throw HttpError.forbidden;
    }
    try {
      final response = await decoratee.request(
        url: '${Flavor.apiBaseUrl}/auth/refresh',
        method: HttpMethod.post,
        body: {'token': token, 'refreshToken': refreshToken},
      );
      final newToken = response['token'] as String;
      final newRefresh = response['refreshToken'] as String?;
      final newRefreshExpiry = response['refreshTokenExpiryTime'] as String?;
      await secureStorage.save(
        key: StorageKeys.accessToken,
        value: newToken,
      );
      if (newRefresh != null) {
        await secureStorage.save(
          key: StorageKeys.refreshToken,
          value: newRefresh,
        );
      }
      if (newRefreshExpiry != null) {
        await secureStorage.save(
          key: StorageKeys.refreshTokenExpiryTime,
          value: newRefreshExpiry,
        );
      }
      return newToken;
    } catch (_) {
      await _clearSessionOnly();
      sl<CurrentAccount>().clear();
      sl<SessionEvents>().notifySessionExpired();
      throw HttpError.forbidden;
    }
  }

  Future<void> _clearSessionOnly() async {
    await secureStorage.delete(key: StorageKeys.accessToken);
    await secureStorage.delete(key: StorageKeys.refreshToken);
    await secureStorage.delete(key: StorageKeys.refreshTokenExpiryTime);
  }
}
