import '../../data/cache/cache.dart';
import '../../data/http/http.dart';
import '../../domain/helpers/helpers.dart';
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
  }) async {
    try {
      final account = await loadCurrentAccount.load();
      final token = account?.accessToken ?? '';
      final authorizedHeaders = Map<String, dynamic>.from(headers ?? {})
        ..addAll({'authorization': 'Bearer $token'});

      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
        queryParameters: queryParameters,
      );
    } on HttpError catch (error) {
      if (error == HttpError.forbidden) {
        await sharedPreferencesStorage.clean();
        throw DomainError.accessDenied;
      }
      rethrow;
    }
  }
}
