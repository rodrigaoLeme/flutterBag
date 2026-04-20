import '../../../../core/entities/logged_user_v2.dart';
import '../../domain/usecases/login_with_id/params.dart';

abstract class LoginWithIdDatasource {
  Future<LoggedUser> call(LoginWithIdParams params);
}
