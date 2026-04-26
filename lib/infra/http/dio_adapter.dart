import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../data/http/http_client.dart';

class DioAdapter implements HttpClient {
  final Dio _dio;

  DioAdapter(this._dio);

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final defaultHeaders = headers?.cast<String, dynamic>() ??
        {
          'content-type': 'application/json',
          'accept': 'application/json',
        };

    final options = Options(
      headers: defaultHeaders,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 24),
    );

    developer.log('>>> $method $url | body: $body', name: 'HTTP');

    try {
      Response? response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            url,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.post:
          response = await _dio.post(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.put:
          response = await _dio.put(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.patch:
          response = await _dio.patch(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.delete:
          response = await _dio.delete(
            url,
            queryParameters: queryParameters,
            options: options,
          );
      }

      return _handleResponse(response);
    } on DioException catch (e) {
      developer.log('<<< ${e.response?.statusCode} | ${e.response?.data}',
          name: 'HTTP ERROR');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw HttpError.timeout;
      }
      if (e.type == DioExceptionType.connectionError) {
        throw HttpError.noConnectivity;
      }
      if (e.response != null) {
        return _handleErrorResponse(e.response!);
      }
      throw HttpError.unexpected;
    }
  }

  dynamic _handleResponse(Response response) {
    developer.log('<<< ${response.statusCode}', name: 'HTTP');
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 204:
        return response.data;
      default:
        throw HttpError.serverError;
    }
  }

  Never _handleErrorResponse(Response response) {
    developer.log('<<< ${response.statusCode} | body: ${response.data}',
        name: 'HTTP ERROR');

    final code = response.data?['code'] as String? ?? '';
    final title = response.data?['title'] as String? ?? '';

    switch (response.statusCode) {
      case 400:
      case 422:
        throw ApiException(
            code: code, title: title, statusCode: response.statusCode ?? 400);
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      case 429:
        throw HttpError.tooManyRequests;
      default:
        throw HttpError.serverError;
    }
  }
}
