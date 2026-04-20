import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../client_exception.dart';
import '../client_interface.dart';
import '../client_response.dart';

class RefreshTokenDioClient implements RefreshTokenClient {
  late final Dio _dioInstance;

  RefreshTokenDioClient({Dio? dio}) : _dioInstance = dio ?? Dio();

  @override
  Future<Either<RefreshTokenClientException, RefreshTokenClientResponse>> getNewSession(String path, dynamic data) async {
    RefreshTokenClientResponse? response;
    try {
      final result = await _dioInstance.post(path, data: data);
      response = RefreshTokenClientResponse(result.data, result.statusCode ?? -1, result.statusMessage ?? '');
      return Right(response);
    } on DioError catch (exception) {
      log(exception.message ?? '');
      return Left(RefreshTokenClientException(exception.message ?? ''));
    }
  }
}
