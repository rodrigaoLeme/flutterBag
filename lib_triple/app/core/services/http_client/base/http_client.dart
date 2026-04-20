import 'package:either_dart/either.dart';

import 'http_client_content_type.dart';
import 'http_client_exception.dart';
import 'http_client_response.dart';

abstract class HttpClient {
  Future<Either<HttpClientException, HttpClientResponse>> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Either<HttpClientException, HttpClientResponse>> post(String path, dynamic data);
  Future<Either<HttpClientException, HttpClientResponse>> put(String path, {dynamic data});
  Future<Either<HttpClientException, HttpClientResponse>> patch(String path, {dynamic data});
  void setBaseUrl(String baseUrl);
  Object fromMap(Map<String, dynamic> map);
  Object multipartFileFromFileSync({required String path, required String filename, ContentType contentType = ContentType.normal});
}
