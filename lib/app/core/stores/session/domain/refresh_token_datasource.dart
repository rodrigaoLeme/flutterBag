import 'refresh_token_params.dart';
import 'refresh_token_result.dart';

abstract class RefreshTokenDatasource {
  RefreshTokenResult call(RefreshTokenParamsV2 params);
}
