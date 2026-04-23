import '../../data/cache/cache.dart';
import '../../data/http/http_client.dart';

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
      final token = await secureStorage.fetch(key: StorageKeys.accessToken);
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
        // Tenta refresh token
        final refreshToken = await secureStorage.fetch(
          key: StorageKeys.refreshToken,
        );
        if (refreshToken == null) {
          await secureStorage.clean();
          throw HttpError.forbidden;
        }
        try {
          final response = await decoratee.request(
            url: '${_baseUrl(url)}/auth/refresh',
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
              key: StorageKeys.refreshToken,
              value: newRefresh,
            );
          }
          final authorizedHeaders = Map<String, dynamic>.from(headers ?? {});
          authorizedHeaders['authorization'] = 'Bearer $newToken';
          return await decoratee.request(
            url: url,
            method: method,
            body: body,
            headers: authorizedHeaders,
            queryParameters: queryParameters,
          );
        } catch (_) {
          await secureStorage.clean();
          throw HttpError.forbidden;
        }
      }
      rethrow;
    }
  }

  String _baseUrl(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}';
  }
}
