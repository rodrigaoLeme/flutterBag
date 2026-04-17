import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';

import '../../data/http/http.dart';

class DioAdapter implements HttpClient {
  final Dio client;
  DioAdapter(
    this.client,
  );

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
    File? file,
  }) async {
    client.interceptors.add(TokenInterceptor(client));
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(method == HttpMethod.multipart
          ? {'content-type': 'multipart/form-data'}
          : {'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    developer.log(
        '=======================================================================',
        name: 'START');
    developer.log('HTTPLOG', name: 'DioAdapter');
    developer.log(url, name: 'URL');
    developer.log(jsonBody ?? '', name: 'BODY');
    developer.log(headers.toString(), name: 'HEADERS');
    developer.log(queryParameters.toString(), name: 'QUERYPARAMETERS');

    final option = Options(
        headers: defaultHeaders,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 24));
    try {
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: queryParameters).toString();

      if (method == HttpMethod.post) {
        final futureResponse =
            await client.post(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.patch) {
        final futureResponse =
            await client.patch(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.get) {
        final futureResponse = await client.get(finalUri, options: option);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.put) {
        final futureResponse =
            await client.put(finalUri, options: option, data: body);
        return _handleResponse(futureResponse);
      } else if (method == HttpMethod.delete) {
        final futureResponse = await client.delete(finalUri, options: option);
        return _handleResponse(futureResponse);
      }
    } catch (error) {
      developer.log(error.toString(), name: 'ERROR');
      throw HttpError.serverError;
    }
  }

  dynamic _handleResponse(Response? response) {
    developer.log(response!.data.toString(), name: 'RESPONSE');
    developer.log(response.statusCode.toString(), name: 'STATUSCODE');
    developer.log(
        '=========================================================================',
        name: 'END');

    switch (response.statusCode) {
      case 200:
        return response.data.isEmpty ? null : response.data;
      case 204:
        return null;
      case 400:
        final json = response.data;
        if (json.containsKey('error')) {
          return response.data.isEmpty ? null : json;
        }
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  TokenInterceptor(this._dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  // ignore: deprecated_member_use
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions requestOptions = err.requestOptions;

      try {
        final opts = Options(
          method: requestOptions.method,
          headers: {
            ...requestOptions.headers,
          },
        );

        final response = await _dio.request(
          requestOptions.path,
          options: opts,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
