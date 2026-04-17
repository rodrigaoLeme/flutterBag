import 'dart:io';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';
import '../../domain/usecases/account/load_current_account.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final LoadCurrentAccount loadCurrentAccount;
  final SharedPreferencesStorage sharedPreferencesStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.loadCurrentAccount,
    required this.sharedPreferencesStorage,
    required this.decoratee,
  });

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
    File? file,
  }) async {
    try {
      final account = await loadCurrentAccount.load();
      String token = account?.email ?? '';
      final authorizedHeaders = headers ?? {}
        ..addAll({'authorization': 'Bearer $token'});
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: queryParameters);
      return await decoratee.request(
        url: finalUri.toString(),
        method: method,
        body: body,
        headers: authorizedHeaders,
        file: file,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        if (error == HttpError.unauthorized) {
          final account = await loadCurrentAccount.load();
          String token = account?.email ?? '';
          final authorizedHeaders = headers ?? {}
            ..addAll({'authorization': 'Bearer $token'});
          return await decoratee.request(
              url: url, method: method, body: body, headers: authorizedHeaders);
        } else {
          rethrow;
        }
      } else {
        await sharedPreferencesStorage.clean();
        throw HttpError.forbidden;
      }
    }
  }
}
