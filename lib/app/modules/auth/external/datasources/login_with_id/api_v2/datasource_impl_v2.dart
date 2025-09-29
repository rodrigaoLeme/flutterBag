import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

import '../../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../../core/entities/logged_user_v2.dart';
import '../../../../../../core/services/http_client/base/http_client.dart';
import '../../../../domain/usecases/login_with_id/exceptions.dart';
import '../../../../domain/usecases/login_with_id/params.dart';
import '../../../../infra/datasources/login_with_id_datasource.dart';
import 'mapper.dart';

class LoginWithIdDatasourceImplV2 implements LoginWithIdDatasource {
  final HttpClient _httpClient;
  final LoginWithIdDatasourceMapperV2 _mapper;
  final EndpointsV2Dev _endpoints;

  LoginWithIdDatasourceImplV2(this._httpClient, this._mapper, this._endpoints);

  @override
  Future<LoggedUser> call(LoginWithIdParams params) async {
    late final LoggedUser entity;
    // change baseUrl for apple test
    if (params.id == "33524461808") {
      Modular.get<HttpClient>()
          .setBaseUrl('https://api-ebolsa-dev.educadventista.org');
    }
    try {
      final result = await _httpClient.post(_endpoints.loginWithId, {
        'username': params.id,
        'password': params.password,
        'baseUri': _endpoints.baseUri,
      });
      result.fold(
        (exception) {
          //TODO(adbysantos): Assumindo que erro 400 é erro de credenciais incorretas
          if (exception.message.contains('400')) {
            throw IncorrectCredentialsException(
                message:
                    "login_with_id_datasource_incorrect_credentials".i18n(),
                stackTrace: StackTrace.empty);
          }
          throw exception;
        },
        (response) {
          final resultFromMapper = _mapper.fromDataToEntity(response.data);
          resultFromMapper.fold(
            (mapperException) {
              throw mapperException;
            },
            (loggedUser) {
              entity = loggedUser;
            },
          );
        },
      );
      return entity;
    } on LoginWithIdException {
      rethrow;
    } catch (unknownException, stackTrace) {
      throw UnknownLoginWithIdException(
          message: "login_with_id_datasource_unknown_exception".i18n(),
          stackTrace: stackTrace);
    }
  }
}
