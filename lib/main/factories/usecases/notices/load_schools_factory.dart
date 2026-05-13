import '../../../../domain/usecases/notices/load_schools.dart';
import '../../../../infra/repositories/notices/remote_load_schools_usecase.dart';
import '../../http/http_factories.dart';

LoadSchoolsUsecase makeRemoteLoadSchools() => RemoteLoadSchoolsUsecase(
      httpClient: makeDioAdapter(),
    );
