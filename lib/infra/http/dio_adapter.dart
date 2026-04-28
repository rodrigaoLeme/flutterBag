import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

      _logRequest(
        method: method,
        url: url,
        headers: options.headers,
        body: body,
        queryParameters: queryParameters,
      );

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

      _logResponse(response);

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

  void _logRequest({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? headers,
    Map? body,
    Map<String, dynamic>? queryParameters,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('[HTTP REQUEST] ${method.name.toUpperCase()} $url')
      ..writeln('headers: ${_encodePretty(_sanitizeHeaders(headers))}')
      ..writeln('queryParams: ${_encodePretty(queryParameters ?? {})}')
      ..writeln('body: ${_encodePretty(_sanitizeBody(body))}');

    debugPrint(buffer.toString());
  }

  void _logResponse(Response? response) {
    if (!kDebugMode || response == null) return;

    final buffer = StringBuffer()
      ..writeln(
        '[HTTP RESPONSE] ${response.requestOptions.method} ${response.requestOptions.uri}',
      )
      ..writeln('statusCode: ${response.statusCode}')
      ..writeln('data: ${_encodePretty(response.data)}');

    debugPrint(buffer.toString());
  }

  String _encodePretty(Object? value) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    } catch (_) {
      return value?.toString() ?? 'null';
    }
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return {};
    final sanitized = Map<String, dynamic>.from(headers);

    sanitized.forEach((key, value) {
      final lowerKey = key.toLowerCase();
      if (lowerKey == 'authorization' || lowerKey == 'cookie') {
        sanitized[key] = '***';
      } else {
        sanitized[key] = value;
      }
    });

    return sanitized;
  }

  Object? _sanitizeBody(Map? body) {
    if (body == null) return null;
    final sanitized = Map<String, dynamic>.from(body.cast<String, dynamic>());

    const sensitiveKeys = {
      'password',
      'newPassword',
      'confirmPassword',
      'refreshToken',
      'token',
      'accessToken',
    };

    sanitized.forEach((key, value) {
      if (sensitiveKeys.contains(key)) {
        sanitized[key] = '***';
      } else {
        sanitized[key] = value;
      }
    });

    return sanitized;
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
