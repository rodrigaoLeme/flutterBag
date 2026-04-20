import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../../endpoints/endpoints_v2_dev.dart';
import '../../../../services/refresh_token_client/client_interface.dart';
import '../../domain/refresh_token_datasource.dart';
import '../../domain/refresh_token_exceptions.dart';
import '../../domain/refresh_token_params.dart';
import '../../domain/refresh_token_result.dart';
import 'mapper.dart';

class RefreshTokenV2Datasource implements RefreshTokenDatasource {
  final EndpointsV2Dev _endpoints;
  final RefreshTokenClient _client;
  final RefreshTokenV2Mapper _mapper;

  RefreshTokenV2Datasource(this._client, this._endpoints, this._mapper);

  @override
  RefreshTokenResult call(RefreshTokenParamsV2 params) async {
    final result = await _client
        .getNewSession('${_endpoints.base}${_endpoints.refreshToken}', {
      'token': params.token,
      'refreshToken': params.refreshToken,
      'baseUri': _endpoints.baseUri
    });
    return result.fold(
      (exception) {
        //TODO(adbysantos): Tratar exceções na requisição de refreshToken
        log('Refresh Token Datasource Exception: ${exception.message}');
        return Left(UnknownTokenException(message: exception.message));
      },
      (response) {
        final result = _mapper.fromJsonToEntity(response.data);
        return result.fold(
          (exception) {
            return Left(exception);
          },
          (user) {
            return Right(user);
          },
        );
      },
    );
  }
}
