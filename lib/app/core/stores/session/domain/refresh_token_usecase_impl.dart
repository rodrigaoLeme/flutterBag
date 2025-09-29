import 'refresh_token_datasource.dart';
import 'refresh_token_params.dart';
import 'refresh_token_result.dart';
import 'refresh_token_usecase.dart';

class RefreshTokenUsecaseImpl implements RefreshTokenUsecase {
  final RefreshTokenDatasource _datasource;

  RefreshTokenUsecaseImpl(this._datasource);

  @override
  RefreshTokenResult call(RefreshTokenParamsV2 params) {
    return _datasource(params);
  }
}
