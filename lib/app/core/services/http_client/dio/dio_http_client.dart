import 'dart:developer' as developer;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:http_parser/http_parser.dart';

import '../../../stores/proxies/token/token_proxy_store.dart';
import '../base/http_client.dart';
import '../base/http_client_content_type.dart';
import '../base/http_client_exception.dart';
import '../base/http_client_response.dart';

class DioHttpClient implements HttpClient {
  final Dio dioInstance;
  final TokenProxyStore _tokenStore;
  late final Dio? retryDioInstance;

  DioHttpClient(this.dioInstance, this._tokenStore, {String? baseUrl}) {
    if (baseUrl != null) {
      setBaseUrl(baseUrl);
    }
    _setRefreshTokenHandler();
    _setTokenInterceptor();
  }

  @override
  void setBaseUrl(String baseUrl) {
    dioInstance.options.baseUrl = baseUrl;
  }

  bool get _isRefreshTokenExpired => _tokenStore.isRefreshTokenExpired;

  void _setRefreshTokenHandler() {
    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isRefreshTokenExpired) {
            handler.reject(DioException(
                requestOptions: options,
                error: const ExpiredRefreshTokenExpcetion()));
            return _tokenStore.refreshTokenExpiredHandler();
          }
          final tokenExpirationCheck = _tokenStore.isTokenExpired;
          return tokenExpirationCheck.fold(
            (exception) => handler.reject(
                DioException(requestOptions: options, error: exception)),
            (isExpired) async {
              if (isExpired) {
                await _tokenStore.refreshToken();
                final tokenExpirationCheckAfterRefresh =
                    _tokenStore.isTokenExpired;
                return tokenExpirationCheckAfterRefresh.fold(
                  (exception) => handler.reject(
                      DioException(requestOptions: options, error: exception)),
                  (isExpiredAfterRefresh) {
                    if (isExpiredAfterRefresh) {
                      handler.reject(DioException(
                          requestOptions: options,
                          error: const CouldNotRefreshAccessTokenException()));
                      _tokenStore.refreshTokenExceptionHandler();
                    } else {
                      handler.next(options);
                    }
                  },
                );
              } else {
                handler.next(options);
              }
            },
          );
        },
        onError: (exception, handler) async {
          final response = exception.response;
          if (_isRefreshTokenExpired) {
            handler.reject(DioException(
                requestOptions: exception.requestOptions,
                error: const ExpiredRefreshTokenExpcetion()));
            return _tokenStore.refreshTokenExpiredHandler();
          }
          //TODO(adbysantos) Verificar uma forma mais assertiva de validar a necessidade de fazer refresh do token
          if (exception.response?.statusCode == 401) {
            await _tokenStore.refreshToken();
            final tokenExpirationCheckAfterRefresh = _tokenStore.isTokenExpired;
            return tokenExpirationCheckAfterRefresh.fold(
              (expirationException) {
                return handler.reject(DioException(
                    requestOptions: exception.requestOptions,
                    error: expirationException));
              },
              (isExpiredAfterRefresh) async {
                if (isExpiredAfterRefresh) {
                  handler.reject(DioException(
                      requestOptions: exception.requestOptions,
                      error: const CouldNotRefreshAccessTokenException()));
                  return _tokenStore.refreshTokenExceptionHandler();
                }
                retryDioInstance ??= Dio()
                  ..options.baseUrl = dioInstance.options.baseUrl;
                Response<dynamic> value;
                try {
                  value = await retryDioInstance!.request(
                    exception.requestOptions.path,
                    data: exception.requestOptions.data,
                    queryParameters: exception.requestOptions.queryParameters,
                    cancelToken: exception.requestOptions.cancelToken,
                    onReceiveProgress:
                        exception.requestOptions.onReceiveProgress,
                    onSendProgress: exception.requestOptions.onSendProgress,
                    options: Options(
                      method: response?.requestOptions.method,
                      sendTimeout: response?.requestOptions.sendTimeout,
                      receiveTimeout: response?.requestOptions.receiveTimeout,
                      extra: response?.requestOptions.extra,
                      headers: response?.requestOptions.headers
                        ?..addAll(
                            {'Authorization': 'Bearer ${_tokenStore.token}'}),
                      responseType: response?.requestOptions.responseType,
                      contentType: response?.requestOptions.contentType,
                      validateStatus: response?.requestOptions.validateStatus,
                      receiveDataWhenStatusError:
                          response?.requestOptions.receiveDataWhenStatusError,
                      followRedirects: response?.requestOptions.followRedirects,
                      maxRedirects: response?.requestOptions.maxRedirects,
                      requestEncoder: response?.requestOptions.requestEncoder,
                      responseDecoder: response?.requestOptions.responseDecoder,
                      listFormat: response?.requestOptions.listFormat,
                    ),
                  );
                  return handler.resolve(value);
                } catch (e) {
                  log('Erro no retry da requisição após realizar refresh de token');
                  log('Erro: ${e.toString()}');
                  if (e is DioException) {
                    handler.next(e);
                  }
                }
              },
            );
          } else {
            handler.next(exception);
          }
        },
      ),
    );
  }

  void _setTokenInterceptor() {
    dioInstance.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        //TODO(adbysantos) Verificar a melhor forma de condicionar a adição do token ao header do http client
        if (!options.path.contains('identity/token')) {
          options.headers
              .addAll({'Authorization': 'Bearer ${_tokenStore.token}'});
        }
        handler.next(options);
      },
    ));
  }

  @override
  Future<Either<HttpClientException, HttpClientResponse>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    HttpClientResponse? response;
    try {
      final result =
          await dioInstance.get(path, queryParameters: queryParameters);
      response = HttpClientResponse(
          result.data, result.statusCode ?? -1, result.statusMessage ?? '');
      developer.log(
          '=======================================================================',
          name: 'START');
      developer.log('HTTPLOG', name: 'HttpAdapter');
      developer.log(path, name: 'URL');
      developer.log('GET', name: 'METHOD');
      developer.log(dioInstance.options.headers.toString(), name: 'HEADERS');
      developer.log(queryParameters.toString(), name: 'QUERYPARAMETERS');
      developer.log(response.toString(), name: 'RESPONSE');
      developer.log(response.statusCode.toString(), name: 'STATUSCODE');
      developer.log(
          '=========================================================================',
          name: 'END');
      return Right(response);
    } on DioException catch (e) {
      return Left(HttpClientException(e.message ?? ''));
    }
  }

  @override
  Future<Either<HttpClientException, HttpClientResponse>> post(
      String path, data) async {
    HttpClientResponse? response;
    try {
      final result = await dioInstance.post(path, data: data);
      response = HttpClientResponse(
          result.data, result.statusCode ?? -1, result.statusMessage ?? '');
      developer.log(
          '=======================================================================',
          name: 'START');
      developer.log('HTTPLOG', name: 'HttpAdapter');
      developer.log(path, name: 'URL');
      developer.log('GET', name: 'METHOD');
      developer.log(dioInstance.options.headers.toString(), name: 'HEADERS');
      developer.log(data.toString(), name: 'BODY');
      developer.log(response.toString(), name: 'RESPONSE');
      developer.log(response.statusCode.toString(), name: 'STATUSCODE');
      developer.log(
          '=========================================================================',
          name: 'END');
      return Right(response);
    } on DioException catch (exception) {
      log(exception.message ?? '');
      return Left(HttpClientException(exception.message ?? ''));
    }
  }

  @override
  Future<Either<HttpClientException, HttpClientResponse>> put(String path,
      {dynamic data}) async {
    HttpClientResponse? response;
    try {
      print(_tokenStore.token);

      final result = await dioInstance.put(path, data: data);
      response = HttpClientResponse(
          result.data, result.statusCode ?? -1, result.statusMessage ?? '');
      developer.log(
          '=======================================================================',
          name: 'START');
      developer.log('HTTPLOG', name: 'HttpAdapter');
      developer.log(path, name: 'URL');
      developer.log('GET', name: 'METHOD');
      developer.log(dioInstance.options.headers.toString(), name: 'HEADERS');
      developer.log(data.toString(), name: 'BODY');
      developer.log(response.toString(), name: 'RESPONSE');
      developer.log(response.statusCode.toString(), name: 'STATUSCODE');
      developer.log(
          '=========================================================================',
          name: 'END');
      return Right(response);
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 400 &&
          exception.response?.data['message'] != null) {
        return Left(
            HttpClientException(exception.response?.data['message'] ?? ''));
      }
      log(exception.message ?? '');
      return Left(HttpClientException(exception.message ?? ''));
    }
  }

  @override
  Future<Either<HttpClientException, HttpClientResponse>> patch(String path,
      {dynamic data}) async {
    HttpClientResponse? response;
    try {
      final result = await dioInstance.patch(path, data: data);
      response = HttpClientResponse(
          result.data, result.statusCode ?? -1, result.statusMessage ?? '');
      developer.log(
          '=======================================================================',
          name: 'START');
      developer.log('HTTPLOG', name: 'HttpAdapter');
      developer.log(path, name: 'URL');
      developer.log('GET', name: 'METHOD');
      developer.log(dioInstance.options.headers.toString(), name: 'HEADERS');
      developer.log(data.toString(), name: 'BODY');
      developer.log(response.toString(), name: 'RESPONSE');
      developer.log(response.statusCode.toString(), name: 'STATUSCODE');
      developer.log(
          '=========================================================================',
          name: 'END');
      return Right(response);
    } on DioException catch (exception) {
      log(exception.message ?? '');
      return Left(HttpClientException(exception.message ?? ''));
    }
  }

  @override
  Object fromMap(Map<String, dynamic> map) => FormData.fromMap(map);

  @override
  Object multipartFileFromFileSync(
      {required String path,
      required String filename,
      ContentType contentType = ContentType.normal}) {
    return MultipartFile.fromFileSync(path,
        filename: filename,
        contentType: contentType == ContentType.pdf
            ? MediaType('application', 'pdf')
            : null);
  }
}

class RefreshTokenInterceptorException implements Exception {
  final String message;

  const RefreshTokenInterceptorException(this.message);

  @override
  String toString() => message;
}

class ExpiredRefreshTokenExpcetion extends RefreshTokenInterceptorException {
  const ExpiredRefreshTokenExpcetion(
      {String message = 'O atributo refresh token está expirado'})
      : super(message);
}

class CouldNotRefreshAccessTokenException
    extends RefreshTokenInterceptorException {
  const CouldNotRefreshAccessTokenException(
      {String message = 'Não foi possível realizar o refresh do token'})
      : super(message);
}
