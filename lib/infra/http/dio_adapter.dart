import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../data/http/http.dart';

class DioAdapter implements HttpClient {
  final Dio client;

  DioAdapter(this.client);

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ??
        {
          'content-type': 'application/json',
          'accept': 'application/json',
        };

    final options = Options(
      headers: defaultHeaders,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 24),
    );

    developer.log('>>> $method $url', name: 'HTTP');

    try {
      Response? response;

      switch (method) {
        case HttpMethod.post:
          response = await client.post(url, options: options, data: body);
        case HttpMethod.get:
          response = await client.get(url,
              options: options, queryParameters: queryParameters);
        case HttpMethod.put:
          response = await client.put(url, options: options, data: body);
        case HttpMethod.patch:
          response = await client.patch(url, options: options, data: body);
        case HttpMethod.delete:
          response = await client.delete(url, options: options);
      }

      return _handleResponse(response);
    } catch (error) {
      developer.log('ERROR: $error', name: 'HTTP');
      throw HttpError.serverError;
    }
  }

  dynamic _handleResponse(Response? response) {
    developer.log('<<< ${response?.statusCode}', name: 'HTTP');
    switch (response?.statusCode) {
      case 200:
        return response?.data;
      case 201:
        return response?.data;
      case 204:
        return null;
      case 400:
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
