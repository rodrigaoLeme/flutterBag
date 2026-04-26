import '../../data/cache/cache.dart';
import '../../data/http/http_client.dart';
import '../../main/flavors.dart';
import '../../share/utils/jwt_decoder.dart';

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
    }
  }

  Future<String> _tryRefresh() async {
    final refreshToken = await secureStorage.fetch(
      key: StorageKeys.refreshToken,
    );
    if (refreshToken == null) {
      await secureStorage.clean();
      throw HttpError.forbidden;
    }
    try {
      final response = await decoratee.request(
        url: '${Flavor.apiBaseUrl}/auth/refresh',
        method: HttpMethod.post,
        body: {'refreshToken': refreshToken},
      );
      final newToken = response['accessToken'] as String;
      final newRefresh = response['refreshToken'] as String?;
      await secureStorage.save(
        key: StorageKeys.accessToken,
        value: newToken,
      );
      if (newRefresh != null) {
        await secureStorage.save(
          key: StorageKeys.accessToken,
          value: newRefresh,
        );
      }
      return newToken;
    } catch (_) {
      await secureStorage.clean();
      throw HttpError.forbidden;
    }
  }
}
