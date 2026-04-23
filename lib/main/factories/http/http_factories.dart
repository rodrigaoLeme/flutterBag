import '../../../data/cache/cache.dart';
import '../../../data/http/http_client.dart';
import '../../../infra/http/dio_adapter.dart';
import '../../decorators/authorize_http_client_decorator.dart';
import '../../di/injection_container.dart';

// Retorna o singleton do cliente HTTP simples (sem token)
HttpClient makeDioAdapter() => sl<DioAdapter>();

// Retorna o singleton do SecureStorage
SecureStorage makeSecureStorage() => sl<SecureStorage>();

// Retorna o singleton do LocalStorage
LocalStorage makeLocalStorage() => sl<LocalStorage>();

// Retorna o singleton do cliente HTTP autenticado (injeta Bearer + refresh)
HttpClient makeAuthorizeHttpClientDecorator() =>
    sl<AuthorizeHttpClientDecorator>();
