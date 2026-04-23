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
    Response? response;

    try {
      final options = Options(headers: headers?.cast<String, dynamic>());

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
      throw _handleDioError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response.data;
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

  HttpError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return HttpError.timeout;
      case DioExceptionType.connectionError:
        return HttpError.noConnectivity;
      case DioExceptionType.badResponse:
        return _handleResponse(e.response!);
      default:
        return HttpError.unexpected;
    }
  }
}
